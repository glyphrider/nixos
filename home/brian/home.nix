{ config, pkgs, inputs, ... }:

{
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    ./packages.nix

    ../common/home.nix
    
    ../optional/emacs.nix
    ../optional/git.nix
    ../optional/gh.nix
    ../optional/hyprland.nix
    ../optional/slack.nix
    
    ./settings/home.nix
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    ".emacs".text = ''
      (setq erlang-root-dir "${pkgs.erlang}/lib/erlang/")
      (setq erlang-lib-dir (concat erlang-root-dir "lib/"))
      (setq erlang-bin-dir (concat erlang-root-dir "bin/"))
      (setq erlang-tools (car (directory-files erlang-lib-dir nil "^tools-.*")))
      (setq erlang-mode-dir (concat erlang-lib-dir erlang-tools "/emacs"))
      (setq load-path (cons erlang-mode-dir load-path))
      (setq exec-path (cons erlang-bin-dir exec-path))
      (require 'erlang-start)
      '';
    ".config/kitty/kitty.conf".text = ''
      background_opacity 0.6
      font_family FiraCode Nerd Font
      shell env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.zsh}/bin/zsh
      '';
    "Pictures/the-matrix-resurrection-digital-rain-city-street.jpeg".source = builtins.fetchurl { url = "https://static1.colliderimages.com/wordpress/wp-content/uploads/2023/05/the-matrix-resurrection-digital-rain-city-street.jpeg"; sha256 = "fbf0647e8f009e8d4b62974836ee2bde65b65aeafa1725db332ce4924916dba8"; };
    ".p10k.zsh".source = ./p10k.zsh;
    ".newsboat/urls".source = ./newsboat-urls;
  };

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
