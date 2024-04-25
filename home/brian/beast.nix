{ config, pkgs, inputs, ... }:
{
  imports = [ ./settings/graphical.nix ./graphical.nix ];
  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",preferred,auto,1.0"
    ];
  };
}
