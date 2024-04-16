{ config, lib, pkgs, ... }:
{
  environment.packages = [ pkgs.obs-studio ];
}
