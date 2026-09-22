# World of Warcraft (Battle.net) non-Steam shortcut

World of Warcraft runs through the Battle.net desktop launcher, which isn't
sold on Steam, so it's added as a **non-Steam shortcut** pointed at
`Battle.net Launcher.exe` inside a Proton prefix, using the pinned GE-Proton
build (`geProtonVersion` in `home.nix`) rather than a stock Steam Play
version.

This directory holds the artwork used for that shortcut's Steam library
grid entry. Nothing here is referenced from the Nix config directly (see
[Grid artwork](#grid-artwork) below) — it's manual Steam user-state, kept
in the repo so it survives a fresh host setup.

## The two-step install

Battle.net can't just be pointed at an existing install, because there
isn't one yet — the Proton prefix has to be created first, and Steam only
creates a shortcut's prefix (`compatdata/<appid>/pfx`) the first time you
launch it. So bootstrapping a new host takes two passes through Steam's
**Properties** dialog for the shortcut:

**Step 1 — install.** Download `Battle.net-Setup.exe` and add/point the
shortcut at the installer itself:

- Target: `/home/brian/Downloads/Battle.net-Setup.exe`
- Start In: `/home/brian/Downloads`
- Compatibility tool: force GE-Proton (the version in `home.nix`)

Launch it. This creates `~/.local/share/Steam/steamapps/compatdata/<appid>/`
and runs the installer inside that fresh prefix, which installs Battle.net
into `.../pfx/drive_c/Program Files (x86)/Battle.net/`.

**Step 2 — repoint at the real launcher.** Once the installer finishes,
find `<appid>` with:

```sh
ls ~/.local/share/Steam/steamapps/compatdata/
```

(it's whatever wasn't there before — the shortcut's appid is a hash of its
Target path + name, so it's stable as long as those don't change). Then
edit Properties again:

- Target: `/home/brian/.local/share/Steam/steamapps/compatdata/<appid>/pfx/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe`
- Start In: `/home/brian/.local/share/Steam/steamapps/compatdata/<appid>/pfx/drive_c/Program Files (x86)/Battle.net`

### The gotcha: leading `/`

Steam's shortcut editor will silently accept a Target/Start In value with
the leading `/` missing (e.g. `home/brian/...` instead of `/home/brian/...`)
— it doesn't error, it just fails to find the executable at launch time,
which looks identical to a plain "launcher won't start" failure. When
pasting these paths in, double check the very first character actually
made it in as `/`.

Once it launches, sanity-check the Hyprland window rule in `home.nix`
matches this shortcut's `<appid>` — it's keyed off the generated Steam
class (`steam_app_<appid>`):

```sh
hyprctl activewindow | grep class
```

If `<appid>` doesn't match the class in `home.nix`'s
`steam_app_<appid>` window rule (fullscreen override for WoW), update it —
the appid isn't guaranteed to stay the same across a from-scratch shortcut
re-creation, only across edits to an *existing* shortcut's paths.

## Grid artwork

Steam's per-game "grid" artwork (used in the Library view) isn't set via
Nix — it's copied into
`~/.local/share/Steam/userdata/<steam-user-id>/config/grid/`, named by
`<appid>`. The files here map to those slots as follows (confirmed by
byte-comparing against a working install, appid `3347315546`):

| File in this directory | Steam grid cache filename | Slot |
|---|---|---|
| `cover.png` | `<appid>p.png` | Portrait/vertical library capsule |
| `wide_cover.png` | `<appid>.png` | Landscape grid capsule |
| `logo.png` | `<appid>_logo.png` | Logo overlay on the hero banner |
| `background.jpg` | `<appid>_hero.png` | Hero banner |
| `icon.png` | *(not copied into grid cache)* | Set via Properties → Icon, browsed directly to this file's absolute repo path |

To apply after a fresh install: right-click the shortcut in Steam →
**Manage → Set custom artwork**, and pick each file for its matching slot
(cover / wide cover / hero). `icon.png` is different — it's set once via
**Properties → Icon**, pointed straight at
`/home/brian/Projects/nixos/pictures/steam_world_of_warcraft/icon.png`, and
Steam reads it from that path live rather than copying it — don't move or
rename the file without updating the shortcut.

`icon.png` was generated from `icon.ico` (which ships multiple embedded
resolutions) by extracting the largest frame and preserving alpha:

```sh
magick "icon.ico[0]" PNG32:icon.png
```
