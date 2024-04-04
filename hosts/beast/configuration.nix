{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network-configuration.nix
    ./extra-filesystems-configuration.nix
    ../optional/amd-graphics-driver-configuration.nix
  ];
}
