{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.swww ];
  home.file."Pictures/the-matrix-resurrection-digital-rain-city-street.jpeg".source = builtins.fetchurl { url = "https://static1.colliderimages.com/wordpress/wp-content/uploads/2023/05/the-matrix-resurrection-digital-rain-city-street.jpeg"; sha256 = "fbf0647e8f009e8d4b62974836ee2bde65b65aeafa1725db332ce4924916dba8"; };
  wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.swww}/bin/swww init" ];
}
