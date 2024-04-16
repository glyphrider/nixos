{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.obs-studio ];
}
