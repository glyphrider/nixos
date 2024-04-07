{ config, pkgs, inputs, ... }:
{
  home.packages = [ pkgs.gh ];
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" "gists.github.com" ];
    };
  };
}
