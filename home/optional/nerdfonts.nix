{ config, pkgs, inputs, ... }:
{
  imports = [ ./font-config.nix ];

  home.packages = [ pkgs.nerdfonts ];
}
