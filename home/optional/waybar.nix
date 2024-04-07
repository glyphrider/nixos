{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.waybar ];
  programs.waybar.enable = true;
}
