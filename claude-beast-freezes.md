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

## Current read

One occurrence: a total hang with nothing written, during a game. The likeliest cause is a GPU or PCIe-level hang (Navi 10 / RX 5700-class card, `1002:731f`). RAM/CPU instability (EXPO/XMP, PBO/undervolt) can't be ruled out. The logs alone can't tell them apart.

## Next steps if it recurs

- Before hitting reset, check whether the mouse cursor still moves and whether audio keeps playing. Then try Alt+SysRq+S/U/B (sync, remount read-only, reboot) — if that works, the kernel was alive. Needs `boot.kernel.sysctl."kernel.sysrq" = 1` (not yet set).
- Note what was running each time. A pattern of freezes only in games points to the GPU. Freezes at idle or on the desktop point to RAM/CPU (try disabling EXPO, run `memtest86+`).
- If it's frequent, set up `netconsole` or a serial console to capture final kernel messages that never reach disk.
