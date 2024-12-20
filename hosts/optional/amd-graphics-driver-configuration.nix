# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
    ];
  };
}

