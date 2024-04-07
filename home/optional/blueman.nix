{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.blueman ];

  wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.blueman}/bin/blueman-applet" ];
}
