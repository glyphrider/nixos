{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.kitty ];
  wayland.windowManager.hyprland.settings.bind = [
    "$mod, Return, exec, ${pkgs.kitty}/bin/kitty"
  ];
}
