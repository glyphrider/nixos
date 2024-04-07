{ config, pkgs, inputs, ... }:
{
  programs.tmux = {
    mouse = true;
    shortcut = "Space";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];
  };
}