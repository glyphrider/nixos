{ config, lib, pkgs, ...}:

{
  # Enable incus
  virtualisation.incus = {
    enable = true;
    preseed = {};
  };
  networking.nftables.enable = true;
}
