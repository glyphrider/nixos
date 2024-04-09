{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  xdg.portal.enable = true;
}
