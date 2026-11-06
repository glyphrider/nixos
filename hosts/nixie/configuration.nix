# Host-specific system config for `nixie`, layered on top of the shared
# ../../configuration.nix.

{ ... }:

{
  # nixie is a System76 Pangolin (pang13) running System76's closed AMI-based
  # BIOS, which has no public release list or LVFS/fwupd support. The only way
  # to check for and install BIOS updates is System76's firmware daemon:
  # `sudo system76-firmware-cli schedule`, then reboot on AC power.
  hardware.system76.firmware-daemon.enable = true;

  # Printing on the home network (10.47.2.0/24), where the printers (Epson
  # ET-2900 and ET-8550) are IPP Everywhere devices that advertise over mDNS.
  # CUPS 2.4 discovers those through avahi (enabled in the shared config) and
  # creates temporary driverless queues on demand, so no drivers or
  # declared hardware.printers are needed. Declared queues would also be a
  # bad fit on a laptop: `lpadmin -m everywhere` queries the printer at
  # activation time and fails when nixie is off that network.
  #
  # cups-browsed defaults to on whenever avahi is enabled, but it's redundant
  # with CUPS's own driverless support and has a history of remotely
  # exploitable bugs (CVE-2024-47176 and friends), so it stays off.
  services.printing = {
    enable = true;
    browsed.enable = false;
  };
}
