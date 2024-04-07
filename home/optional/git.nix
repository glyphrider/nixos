{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
}
