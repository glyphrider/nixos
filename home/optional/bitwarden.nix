{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.bitwarden ];
}
