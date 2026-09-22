# PLACEHOLDER — beast has not been installed yet. This file exists only so
# the flake's directory layout is complete; every value in it is fake.
#
# Before installing NixOS on beast:
#   1. Boot the NixOS installer on beast and partition/format the disks
#      (plain btrfs with @/@home/@nix subvolumes, matching stealth — see
#      hosts/stealth/hardware-configuration.nix for the pattern, or use a
#      different layout if you decide against btrfs for this machine).
#   2. Mount the new filesystems under /mnt, then run:
#        nixos-generate-config --root /mnt
#   3. Copy the real /mnt/etc/nixos/hardware-configuration.nix over this
#      file (replacing it entirely — don't hand-merge).
#   4. From this repo (cloned onto /mnt or reachable from the installer),
#      run:
#        nixos-install --root /mnt --flake .#beast
#
# flake.nix's `monitors = [ "*" ]` for beast is hyprpaper's wildcard, so it
# doesn't need updating once the real DP connector names are known -- only
# switch to explicit names (via `hyprctl monitors`) if per-monitor
# wallpapers are ever wanted.
#
# Do not hand-edit this file otherwise — like every hardware-configuration.nix
# in this repo, it's meant to be machine-generated and treated as read-only.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/0000-0000";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
