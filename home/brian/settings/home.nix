{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bash.nix
    ./git.nix
    ./hyprland.nix
    ./swaylock.nix
    ./tmux.nix
    ./vim.nix
    ./waybar.nix
    ./wofi.nix
    ./zsh.nix
  ];
}