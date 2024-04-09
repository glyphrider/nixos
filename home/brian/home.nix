{ config, pkgs, inputs, ... }:

{
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    ./packages.nix

    ../common/home.nix
    
    ../optional/bitwarden.nix
    ../optional/blueman.nix
    ../optional/cmdline-utils.nix
    ../optional/cmus.nix
    ../optional/discord.nix
    ../optional/emacs.nix
    ../optional/erlang.nix
    ../optional/eza.nix
    ../optional/firefox.nix
    ../optional/fzf.nix
    ../optional/gaming.nix
    ../optional/gimp.nix
    ../optional/git.nix
    ../optional/gh.nix
    ../optional/google-chrome.nix
    ../optional/hyprland.nix
    ../optional/newsboat.nix
    ../optional/slack.nix
    
    ./settings/home.nix
  ];

  home.activation.xdg = ''
    echo '> using xdg-user-dirs to ensure "standard" folders exist in home'
    "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update"
    '';

  home.activation.ssh-dir = ''
    umask 077 && mkdir -pv ~/.ssh
    '';
  home.sessionVariables = {
    EDITOR = "vim";
    VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
  };

  programs.home-manager.enable = true;
}
