# beast: hard freezes and crashes (reopened)

Log of full-system freezes and crashes on `beast`. **Thought resolved 2026-10-21:** a bad RAM stick was found and removed, so beast now runs with 64 GB instead of 128 GB. **Reopened 2026-10-26:** the same random GCC crashes came back with only the remaining sticks installed (see below). Add any new occurrence below.

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

### 2026-10-26 — GCC crashes again, after the bad stick was removed

- Full `nixos-rebuild build` of beast after a `nix flake update` to nixpkgs `3ec6363`. `cc1plus` (GCC 16.2.0) crashed with `internal compiler error: Segmentation fault` in two separate build attempts: first in `hyprgraphics` (`tests/arg.cpp`, from the Hyprland input), then in `glaze-9.0.0` (`fuzzing/repe_registry.cpp`).
- `hyprgraphics` built cleanly twice when rebuilt on its own. Not deterministic, same as on 2026-10-21.
- Both backtraces end in GCC's garbage collector (`ggc_set_mark` ← `gt_ggc_mx_lang_tree_node`, recursing deeply). The same crash site twice weakly suggests a real GCC 16.2 bug rather than random bit flips. But the GC walks large amounts of memory, so it's also where a flipped bit would most likely show up. The 2026-10-21 backtraces weren't recorded, so they can't be compared.
- No coredumps today, and no MCE/EDAC/kernel trap messages on this boot. Stack limit is 8192 KB (default).
- The remaining RAM has passed Memtest86+ (per the user). Memtest doesn't load the CPU's memory controller the way an all-core build does, and the A-XMP/PBO settings after the BIOS update still haven't been checked.

## Earlier conclusion (2026-10-21)

A bad RAM stick was blamed for both the 2026-10-05 freeze and the 2026-10-21 compiler crashes. The user removed it, and beast now runs with 64 GB. No config changes were needed. The Memtest86+ GRUB entry in `configuration.nix` was added during this investigation and stays. The 2026-10-26 recurrence shows the removed stick was at most part of the cause.

## Next steps

- Check the BIOS memory settings (MSI Click BIOS: EZ Mode top-left A-XMP toggle, or Advanced/F7 → OC → Extreme Memory Profile (A-XMP)). Write down the current DRAM speed and voltage, then set A-XMP to Disabled (JEDEC speed) and redo a full-parallelism build. If the GCC crashes stop, it's the memory overclock or the memory controller, not a bad stick. Then try a middle speed.
- If crashes continue at stock settings, test the remaining sticks one at a time under a heavy parallel build (e.g. repeated `nix build --rebuild` of a large C++ package), not just Memtest86+.
- Before hitting reset, check whether the mouse cursor still moves and whether audio keeps playing. Then try Alt+SysRq+S/U/B (sync, remount read-only, reboot) — if that works, the kernel was alive. Needs `boot.kernel.sysctl."kernel.sysrq" = 1` (not yet set).
- Note what was running each time. A pattern of freezes only in games points to the GPU. Freezes at idle, on the desktop, or random crashes under all-core load point to RAM/CPU. Run Memtest86+ from the GRUB menu, and suspect another stick first.
- If it's frequent, set up `netconsole` or a serial console to capture final kernel messages that never reach disk.
