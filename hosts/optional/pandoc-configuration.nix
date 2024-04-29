{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.pandoc
    pkgs.texlive.combined.scheme-small
  ];
}
