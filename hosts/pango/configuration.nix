{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network-configuration.nix
    ../optional/amd-graphics-driver-configuration.nix
    ../optional/plasma-configuration.nix
    ../optional/sway-configuration.nix
  ];
}
