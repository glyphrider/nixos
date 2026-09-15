# Edit this configuration file to define what should be installed on your system. Help is available in the 
# configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let
  # NFS shares exported by the NAS, automounted on first access and
  # unmounted after being idle so boot/login never blocks on the NAS
  # being reachable. The NAS only exports NFSv3 (confirmed via
  # `rpcinfo -p`; NFSv4 mounts fail with "Protocol not supported").
  nasMount = remotePath: {
    device = "192.168.1.4:${remotePath}";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
      "x-systemd.mount-timeout=10s"
      "soft"
      "timeo=100"
      "retry=2"
      "nfsvers=3"
      "proto=tcp"
      "_netdev"
    ];
  };

in
{
  imports = [ inputs.silent-sddm.nixosModules.default ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    gfxmodeEfi = "1920x1080";
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.plymouth = {
    enable = true;
  };
  boot.kernelParams = [ "quiet" "splash" ];

  # networking.hostName is set per-host in flake.nix's mkHost.

  networking.networkmanager.enable = true;

  time.timeZone = "US/Eastern";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };

  programs.steam.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Was regreet-under-cage, but cage (a single-app kiosk compositor) has no
  # real monitor-mirroring mode - only "last" (one output) or "extend"
  # (stitches every output into one virtual desktop), which made the
  # greeter stretch across both of stealth's monitors instead of showing on
  # each. SDDM's Wayland greeter draws a separate fullscreen window per
  # connected output (see sddm's GreeterApp::addViewForScreen, which
  # iterates every QGuiApplication screen), so both monitors show the same
  # login prompt without any per-host monitor config needed. silentSDDM's
  # bundled "nord" config gives us that look without pulling in KDE Plasma
  # Frameworks the way most other Nord-styled SDDM themes do - it's plain
  # Qt6/QML, so its dependency footprint is comparable to plain SDDM itself.
  programs.silentSDDM = {
    enable = true;
    theme = "nord";
    profileIcons.brian = ./pictures/brian.jpg;
  };
  services.displayManager.defaultSession = "hyprland-uwsm";

  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.kmscon = {
    enable = true;
    config = {
      hwaccel = true;
      font-engine = "pango";
      font-size = 14;
      font-name = "JetBrainsMono Nerd Font Mono";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.caskaydia-cove
    nerd-fonts.noto
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.brian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "audio" "dialout" "networkmanager" ];
    shell = pkgs.zsh;
    linger = true;
    # Applied only if the account has no password yet, so `passwd` changes
    # made after first boot survive future rebuilds instead of being reset.
    initialHashedPassword = "$6$X47Tox8O5qyaLLqF$oSedhd3d4BXr4XnnMdYYtaLrNNC0KlK4Jk5YWWv6cvis5.GDaJ1tZa8hJPQdyAQwuBl9EFGoAzt1Kkoxx/1lS.";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    pango
  ];

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  fileSystems."/media/movies" = nasMount "/mnt/tank/media/movies";
  fileSystems."/media/shows" = nasMount "/mnt/tank/media/shows";
  fileSystems."/media/music" = nasMount "/mnt/tank/media/music";
  fileSystems."/archive" = nasMount "/mnt/tank/archive";

  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

