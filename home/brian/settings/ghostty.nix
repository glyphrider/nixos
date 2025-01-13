{ config, pkgs, inputs, ... }:

{
  home.file.".config/ghostty/config".text = ''
    window-decoration = false
    background-opacity = 0.6
    font-family = FiraCode Nerd Font
    command = env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.zsh}/bin/zsh
    theme = GitHub Dark
  '';
}
