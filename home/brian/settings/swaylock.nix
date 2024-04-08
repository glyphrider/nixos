{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland.settings.bind = [
    "$mod, L, exec, ${pkgs.swaylock-effects}/bin/swaylock"
  ];
  programs.swaylock = {
    package = pkgs.swaylock-effects;
    settings = {
      indicator = true;
      clock = true;
      screenshots = true;
      effect-greyscale = true;
      effect-blur="4x4";
      effect-vignette="0:0.5";
      indicator-radius=200;
      indicator-thickness=50;
    };
  };
}
