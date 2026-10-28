# Host-specific system config for `nixie`, layered on top of the shared
# ../../configuration.nix.

{ ... }:

{
  # nixie is a System76 Pangolin (pang13) running System76's closed AMI-based
  # BIOS, which has no public release list or LVFS/fwupd support. The only way
  # to check for and install BIOS updates is System76's firmware daemon:
  # `sudo system76-firmware-cli schedule`, then reboot on AC power.
  hardware.system76.firmware-daemon.enable = true;
}
