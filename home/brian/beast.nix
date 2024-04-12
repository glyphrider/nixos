{ config, pkgs, inputs, ... }:
{
  imports = [ ./graphical.nix ];
  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1.0"
    ];
  };
}
