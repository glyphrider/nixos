# System configuration (configuration.nix, hardware-configuration.nix, flake.nix inputs)

Covers the system-level side of the flake: `configuration.nix`, `hardware-configuration.nix`, and the flake inputs that back system services.

## Non-obvious constraints

- **Hyprland is pinned** in `flake.nix` to a specific commit (see the comment above the `hyprland.url` input) because a later Hyprland change (hyprwm/Hyprland#16140) dropped the numeric workspace `id` from hyprctl's JSON in favor of `address`, breaking Waybar's `hyprland/workspaces` module (it shows only "0"). Don't bump this input without first checking whether Waybar's module has been updated to support address-based workspace identity.
- **`programs.hyprland` here (system) vs. `wayland.windowManager.hyprland` in `home.nix` (home-manager) are both configured, deliberately split**: this module provides the compositor package (`inputs.hyprland.packages.*.hyprland`) and the XDG portal package, while home-manager's module has `package = null` / `portalPackage = null` and only supplies user-level Lua config. Don't let home-manager pull in its own Hyprland package — see @claude-home.md.
- **NFS mounts** (`nasMount` helper) target NFSv3 specifically — the NAS only exports NFSv3 (confirmed via `rpcinfo -p`); NFSv4 mounts fail with "Protocol not supported". They're automount/idle-unmount (`x-systemd.automount`, `x-systemd.idle-timeout=600`) so boot/login never blocks on the NAS being reachable. Keep that pattern for any new NAS-backed mount.
- `hardware-configuration.nix` is machine-generated — never hand-edit it; re-run `nixos-generate-config` if the disk layout changes and reconcile manually.
- `system.stateVersion` (`"25.11"`) should not be bumped without deliberately intending a NixOS release migration.
- The NAS IP (`192.168.1.4`) is specific to this physical network — don't genericize it.
