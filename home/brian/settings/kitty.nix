{ config, pkgs, inputs, ... }:

{
  home.file.".config/kitty/kitty.conf".text = ''
    background_opacity 0.6
    font_family FiraCode Nerd Font
    shell env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.zsh}/bin/zsh
  '';
}
