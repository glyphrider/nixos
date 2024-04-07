{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bash.nix
    ./dunst.nix
    ./emacs.nix
    ./git.nix
    ./hyprland.nix
    ./kitty.nix
    ./newsboat.nix
    ./swaylock.nix
    ./tmux.nix
    ./vim.nix
    ./wallpaper.nix
    ./waybar.nix
    ./wofi.nix
    ./zsh.nix
  ];
}
