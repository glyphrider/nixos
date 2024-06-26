# This sets up networking for an unmanaged bridge to be used with LXD.
#
# Note that by default LXD uses a managed bridge, that also runs dnsmasq to do
# things like DNS and DHCP to your containers.  I don't need all of that, and
# dnsmasq seems to crash quite often, so this module just sets up an unmanaged
# bridge.

{ config, lib, pkgs, ...}:

{
  # Enable LXD.
  virtualisation.lxd = {
    enable = true;

    # This turns on a few sysctl settings that the LXD documentation recommends
    # for running in production.
    recommendedSysctlSettings = true;
  };

  # This enables lxcfs, which is a FUSE fs that sets up some things so that
  # things like /proc and cgroups work better in lxd containers.
  # See https://linuxcontainers.org/lxcfs/introduction/ for more info.
  #
  # Also note that the lxcfs NixOS option says that in order to make use of
  # lxcfs in the container, you need to include the following NixOS setting
  # in the NixOS container guest configuration:
  #
  # virtualisation.lxc.defaultConfig = "lxc.include = ''${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";
  virtualisation.lxc.lxcfs.enable = true;

}
