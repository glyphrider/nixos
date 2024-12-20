# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  fonts.packages = with pkgs.nerd-fonts; [
    arimo
    hack
    fira-code
    noto
  ];

  security.polkit.enable = true;

  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable =true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  hardware.gpgSmartcards.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.rtkit.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };
  programs.xfconf.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.wireshark.enable = true;

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
}

