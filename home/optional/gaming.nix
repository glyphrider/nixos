{ config, pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.steam
    # pkgs.lutris
    pkgs.wineWowPackages.stable
  ];
}
