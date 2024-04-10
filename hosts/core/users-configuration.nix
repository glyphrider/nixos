{ config, lib, pkgs, ... }:

{
  nix.settings.allowed-users = [ "brian" ];
  
  users.users.brian = {
    description = "Brian H. Ward";
    createHome = true;
    home = "/home/brian";
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "kvm" "input" "disk" "libvirtd" "qemu-libvirtd" "lxd" "incus-admin" "wireshark" "adbusers" "networkmanager" "tty" ];
    packages = with pkgs; [
    ];
  };
}
