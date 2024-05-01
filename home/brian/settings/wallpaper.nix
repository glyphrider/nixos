{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.swww ];
  home.file."Pictures/the-matrix-resurrection-digital-rain-city-street.jpeg".source = builtins.fetchurl { url = "https://static1.colliderimages.com/wordpress/wp-content/uploads/2023/05/the-matrix-resurrection-digital-rain-city-street.jpeg"; sha256 = "fbf0647e8f009e8d4b62974836ee2bde65b65aeafa1725db332ce4924916dba8"; };
  home.file."Pictures/nix-wallpaper-nineish-dark-gray.png".source = builtins.fetchurl { url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/c68a508b95baa0fcd99117f2da2a0f66eb208bbf/wallpapers/nix-wallpaper-nineish-dark-gray.png"; sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly"; };
  home.file."Pictures/nix-wallpaper-stripes-logo.png".source = builtins.fetchurl { url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/c68a508b95baa0fcd99117f2da2a0f66eb208bbf/wallpapers/nix-wallpaper-stripes-logo.png"; sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl"; };
  wayland.windowManager.hyprland.settings.exec-once = [ "${pkgs.swww}/bin/swww init" ];
}
