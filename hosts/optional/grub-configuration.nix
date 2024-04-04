{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot";
    };
  };
  # boot.plymouth.enable = true;

  # Need to setup a random host id with
  # :r !cut -c4 /dev/urandom | od -A none -t x4
  # networking.hostId = 
}

