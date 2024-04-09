{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network-configuration.nix
    ./extra-filesystems-configuration.nix
    ../optional/amd-graphics-driver-configuration.nix
  ];

  zramSwap.memoryMax = 16 * 1024 * 1024 * 1024;
  boot.loader.grub.memtest86.enable = true;
}
