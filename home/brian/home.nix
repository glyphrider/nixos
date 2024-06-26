{ config, pkgs, inputs, ... }:

{
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    ./packages.nix
    ./settings/home.nix

    ../common/home.nix

    ../optional/git.nix
    ../optional/gh.nix
  ];

  home.activation.ssh-dir = ''
    umask 077 && mkdir -pv ~/.ssh
    '';
  home.sessionVariables = {
    EDITOR = "vim";
    GSETTINGS_BACKEND = "keyfile";
  };
  programs.home-manager.enable = true;
}
