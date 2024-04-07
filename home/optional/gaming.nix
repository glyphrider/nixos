{ config, pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.lutris
    pkgs.steam
    pkgs.wineWowPackages.stable
  ];
}
