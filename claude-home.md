# Home-manager configuration (home.nix)

Covers `home.nix`, the home-manager config for user `brian`: shell, terminal apps, Hyprland/Waybar/hyprlock/hypridle/mako, Firefox, git/gh, and a couple of custom derivations.

## Non-obvious constraints

- **`wayland.windowManager.hyprland` here has `package = null` / `portalPackage = null`, `configType = "lua"`, `systemd.enable = false`**: the compositor package itself comes from the system module in `configuration.nix` (see @claude-system.md); this module only supplies user-level Lua config (binds, window rules, monitor setup). Don't remove the `null` packages or home-manager will pull in its own Hyprland build alongside the system one.
- **Window-rule comments encode real hardware/app quirks** — read them before touching the block:
  - The Bitwarden vault-unlock popup opens as a separate Chrome extension window (`chrome-nngceckbapebfimnlniiiahkandclblb-Default`), not a popup layer, so it needs an explicit float rule.
  - The `steam_app_8500` (EVE Online) rules are ordered/scoped specifically: match by title `^EVE$` for the game window's forced fullscreen, a separate size/position rule for `EVE Launcher` (its self-reported `window_w/window_h` reflect the pre-rule size, so literal offsets are used), and a `suppress_event = "fullscreen"` rule to block the launcher's own delayed fullscreen request. Change these together, not independently.
- **`edifier-bluetooth-autoconnect` (systemd user service) retries on a loop** because wireplumber's A2DP endpoints don't exist yet when the bluetooth adapter powers on at boot; it's ordered `After`/`PartOf` wireplumber specifically so it also re-fires across suspend/resume when wireplumber restarts. The Bluetooth MAC (`64:68:76:70:F3:FE`) is hardware-specific — don't genericize it.
- **`home.activation.installGEProton` copies rather than symlinks** the GE-Proton derivation into `~/.local/share/Steam/compatibilitytools.d/`: `home.file` with `recursive = true` symlinks individual files, and GE-Proton's `copy_pfx()` preserves those symlinks into per-game wine prefixes, which then point back at the read-only Nix store and crash with `EROFS`. The `.nix-source` marker file is how the activation script detects "already installed, skip the copy."
- `xdg.configFile."nvim"` sources the `nvim-config` flake input (`glyphrider/kickstart.nvim`) recursively — Neovim config itself lives in that separate repo, not here.
- `home.stateVersion` (`"25.11"`) should not be bumped without deliberately intending a home-manager release migration.
