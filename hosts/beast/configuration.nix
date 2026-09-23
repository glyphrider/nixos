# Host-specific system config for `beast`, layered on top of the shared
# ../../configuration.nix. Anything here is true for this physical desktop
# only — not for other hosts built from this flake.

{ ... }:

{
  # Bluetooth itself is enabled in the shared configuration.nix. Unlike
  # stealth, beast's Edifier speakers are wired via TOSLink (optical S/PDIF)
  # rather than Bluetooth, so there's no pairing/autoconnect step needed —
  # pipewire picks up the optical output like any other ALSA sink. See
  # hosts/stealth/home.nix's edifier-bluetooth-autoconnect for the Bluetooth
  # version this replaces.

  # beast's BD-RE drive (../../../ripping flake, MakeMKV) needs SCSI
  # passthrough, not just the /dev/sr0 block device: MakeMKV talks to optical
  # drives over /dev/sg*, which only exists once the `sg` module is loaded.
  boot.kernelModules = [ "sg" ];

  # /dev/sg* covers every SCSI device on the bus, not just optical drives —
  # on beast that's also the two SATA SSDs (sg0/sg1) and any USB mass storage
  # plugged in, and sg allows raw SCSI command passthrough (e.g. a format
  # unit command), so opening it to the `cdrom` group at large would be a
  # real risk to those disks. Scope the rule to SCSI type 5 (CD-ROM) so only
  # the optical drive's sg node (sg2, but the number can shift as devices are
  # plugged in) gets group access.
  services.udev.extraRules = ''
    SUBSYSTEM=="scsi_generic", ATTRS{type}=="5", GROUP="cdrom", MODE="0660"
  '';
}
