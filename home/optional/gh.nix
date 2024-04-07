{ config, pkgs, inputs, ... }:
{
      programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" "gists.github.com" ];
    };
  };
}