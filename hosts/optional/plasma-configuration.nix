{ config, lib, pkgs, ... }:

{
  services = {
    desktopManager.plasma6.enable = true;
    xserver.enable = true;
    displayManager.sddm = {
      #enable  = true;
      wayland.enable = true;
    };
  };
}
