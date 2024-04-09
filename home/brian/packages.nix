{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    gnome3.adwaita-icon-theme
    rustup # used to install a version of rust
    wireshark # wireshark seems to need both the package *and* the programs.wireshark.enable = true
    xdg-user-dirs
  ];
}
