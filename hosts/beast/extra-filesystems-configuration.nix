{ config, lib, pkgs, ... }:
{
  fileSystems = {
    "/home/brian/Games" = { # Games is an additional Steam Library, so I can reinstall the OS without having to reinstall Steam Games
      depends = [ "/" "/home" ];
      device = "/dev/disk/by-uuid/d1a11a3d-52f2-4f88-bef5-c1abcb68c56f";
      options = [ "defaults" "noatime" "nodiratime" ];
    };
#    "/var/lib/libvirt" = { # This is an volume to keep VMs persistant across OS reinstalls (only somewhat effective)
#      depends = [ "/" "/var" ];
#      device = "/dev/disk/by-uuid/3ec5b0fb-b766-40e4-982e-fd948fe52495";
#      options = [ "noatime" ];
#    };
  };
}
