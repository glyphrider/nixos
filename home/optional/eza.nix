{ config, pkgs, inputs, ... }:
{
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };
}
