{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
  };
}