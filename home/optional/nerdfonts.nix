{ config, pkgs, inputs, ... }:
{
  imports = [ ./font-config.nix ];

  home.packages = with pkgs.nerd-fonts; [
    arimo
    hack
    fira-code
    noto
  ];
}
