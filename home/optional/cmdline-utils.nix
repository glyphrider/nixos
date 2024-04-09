{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    cmatrix
    cowsay
    fortune
    htop
    neofetch
  ];
}
