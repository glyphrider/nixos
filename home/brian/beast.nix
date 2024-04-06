{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1.0";
    ];
  };
}
