{ config, pkgs, inptus, ... }:
{
  programs.bash.shellAliases = {
    h = "dbus-launch --exit-with-session Hyprland";
  };
}