{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,1920x1080@144,2560x0,1.0"
      "HDMI-A-1,2560x1440@60,0x0,1.0"
    ];
  };
}
