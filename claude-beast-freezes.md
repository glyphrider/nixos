# beast: hard freezes (open investigation)

Running log of full-system freezes on `beast`. Add each new occurrence below and update the "Current read" section as evidence accumulates. Nothing has been changed in the config in response yet.

## How to investigate a new occurrence

1. `journalctl --list-boots` and `last -x | head` — the frozen boot shows as `crash` in `last`.
2. `journalctl -b -1 -o short-precise | tail -80` — find the last line written. The NetworkManager dispatcher logs every ~2.5 min, so a missing tick brackets when it froze.
3. `journalctl -b -1 | grep -iE 'panic|oops|BUG:|lockup|mce|hardware error|amdgpu.*(reset|timeout|hang|fault)|ring .* timeout|oom|segfault'` and `coredumpctl list`.
4. `journalctl -b 0 -k | grep -i 'reset reason'` — the firmware's reset reason for the *previous* boot. `BP_SYS_RST_L was tripped` = reset button; `0xCF9` = normal software reboot; `ACPI power state transition` = normal power-off/on.
5. `ls /sys/fs/pstore/ /var/lib/systemd/pstore/` — a kernel panic would leave a dump here.

**Baseline noise — present on every boot, including clean ones, so not related:** `Fence fallback timer expired on ring sdma0` at amdgpu init, `clocksource: Watchdog remote CPU N read timed out`, `amd_pstate: failed to register with return -19`.

## Occurrences

### 2026-10-05 ~08:09 EDT

- Boot `dcc91b25f21f4a3e98ec6f8b5ce57426` (06:23–08:08). Running: EVE Online (Steam app 8500) under Proton. Its launcher had spawned a new process at 08:08:13.
- The last journal line was at 08:08:34 (routine). The 08:10:54 dispatcher tick never logged, so the freeze happened between 08:08:35 and 08:10:54.
- No panic, oops, lockup, amdgpu timeout/reset, MCE, OOM, or coredump. pstore empty.
- Recovered by pressing the reset button (confirmed by the user; the firmware reset reason was `BP_SYS_RST_L`). Not checked before reset: whether the mouse/audio still worked or SysRq responded.

## Related evidence (not freezes)

### BIOS update (between 2026-10-05 and 2026-10-21)

- The user updated beast's BIOS to MSI `1.S3` (dated 2026-08-18; board MEG X570 ACE / MS-7C35, CPU Ryzen 9 3950X). Several kernel startup warnings disappeared afterwards. No freezes since, and the machine ran smoothly for days.
- A BIOS update normally resets all settings to defaults and changes the AGESA, so memory/CPU settings (A-XMP, PBO, voltages) may differ from before. Not yet checked what they're set to now.

### 2026-10-21 — compilers crashing under full-load nix builds

- `cc1plus` (GCC 16.2.0) crashed with `internal compiler error: Segmentation fault` three times (~10:00–12:20 EDT) in from-source builds of `aquamarine` (`src/backend/drm/Renderer.cpp`) and `hyprtoolkit`, pulled in by the `hyprpaper` input after a nixpkgs bump to `02c087f`.
- `emacs` also SIGSEGV'd three times (11:04, 12:02, 12:02) under nixbld uid 30011, most likely while byte-compiling Emacs packages during a build. These show up in `coredumpctl list`; the GCC crashes don't, because GCC catches its own SIGSEGV and reports an ICE instead.
- `aquamarine` built cleanly when rebuilt on its own, so the crashes aren't deterministic.
- Load average was ~36 on 32 threads, with 118 GB of 125 GB RAM free, so memory pressure and OOM are ruled out. No MCE, EDAC, or kernel trap messages on this boot. The machine itself stayed up — no freeze or reboot.
- Different processes crashing at random, only under all-core load and not when retried alone, is a classic symptom of RAM/CPU instability. This points toward the "RAM/CPU" side of the question below.

## Current read

One freeze: a total hang with nothing written, during a game. On its own it looked like a GPU or PCIe-level hang (Navi 10 / RX 5700-class card, `1002:731f`). But the 2026-10-21 compiler crashes under full load are strong evidence of RAM/CPU instability, which could also explain the freeze. Treat RAM/CPU as the leading suspect until the checks below clear it.

## Next steps for the RAM/CPU suspicion

1. In the BIOS, check whether A-XMP is on, what memory speed it's set to, and whether PBO/Curve Optimizer is on. If XMP is on, disable it and rerun the build that failed. If the crashes stop, it's the memory overclock.
2. Run `memtest86+` for at least one full pass — it is in the GRUB boot menu on all hosts (`boot.loader.grub.memtest86.enable`).
3. Stress the CPU outside nix (`stress-ng` or `y-cruncher`, all cores) to see whether errors reproduce without the build system. Some 3950X chips have a single weak core that only fails under all-core load.

## Next steps if it recurs

- Before hitting reset, check whether the mouse cursor still moves and whether audio keeps playing. Then try Alt+SysRq+S/U/B (sync, remount read-only, reboot) — if that works, the kernel was alive. Needs `boot.kernel.sysctl."kernel.sysrq" = 1` (not yet set).
- Note what was running each time. A pattern of freezes only in games points to the GPU. Freezes at idle or on the desktop point to RAM/CPU (try disabling EXPO, run `memtest86+`).
- If it's frequent, set up `netconsole` or a serial console to capture final kernel messages that never reach disk.
