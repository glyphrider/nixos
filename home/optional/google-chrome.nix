{ config, pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = [ pkgs.google-chrome ];
}
