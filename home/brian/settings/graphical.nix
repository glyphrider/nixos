{ config, pkgs, inputs, ... }:
{
  imports = [
    ./dunst.nix
    ./hyprland.nix
    ./kitty.nix
    ./newsboat.nix
    ./swaylock.nix
    ./wallpaper.nix
    ./waybar.nix
    ./wofi.nix
  ];
}
