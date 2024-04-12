{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    gnome3.adwaita-icon-theme
    wireshark # wireshark seems to need both the package *and* the programs.wireshark.enable = true
    xdg-user-dirs
  ];
}
