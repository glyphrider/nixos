# Host-specific system config for `nixie`, layered on top of the shared
# ../../configuration.nix.

{ ... }:

{
  # linux-firmware's 20260910 release broke DMCUB firmware load on Rembrandt
  # APUs (Radeon 680M, which is what nixie has), causing "[drm] *ERROR*
  # Error queuing DMUB command" and slow/glitchy boot -- a known upstream
  # regression (see e.g. the CachyOS/Arch bug reports on
  # linux-firmware-amdgpu 20260910-1). Pin back to the last known-good tag
  # (20260810) until upstream reverts/fixes it, then drop this override.
  nixpkgs.overlays = [
    (final: prev: {
      linux-firmware = prev.linux-firmware.overrideAttrs (old: {
        version = "20260810";
        src = prev.fetchFromGitLab {
          owner = "kernel-firmware";
          repo = "linux-firmware";
          tag = "20260810";
          hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
        };
      });
    })
  ];
}
