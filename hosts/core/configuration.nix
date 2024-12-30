{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./users-configuration.nix
  ];

  zramSwap.enable = true;

  time.timeZone = "US/Eastern";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "sun12x22";
  };

  security.polkit.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  hardware.gpgSmartcards.enable = true;

  security.rtkit.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.wireshark.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  environment.systemPackages = with pkgs; [
    efibootmgr
    file
    gh
    gitFull
    home-manager
    just
    nfs-utils
    openssl
    pinentry-curses
    vim
  ];

  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 9100 ];
  };
  
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

