{ config, lib, pkgs, ... }:

{
  networking.hostName = "beast"; # Define your hostname.
  networking.domain = "marisol.home";

  networking.hostId = "50b62111";

  networking.networkmanager.enable = false;  # Easiest to use and most distros use this by default.

  networking.useNetworkd = true;

  networking.nameservers = [ "192.168.47.2" ];
  networking.search = [ "marisol.home" ];
  networking.defaultGateway = {
    interface = "br0";
    address = "192.168.47.1";
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "10-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
          MACAddress = "B6:86:EA:F0:DE:2E";
        };
      };
      "10-vlan3" = {
        netdevConfig = {
          Name="vlan3";
          Kind="vlan";
        };
        vlanConfig.Id=3;
      };
      "10-vlan113" = {
        netdevConfig = {
          Name="vlan113";
          Kind="vlan";
        };
        vlanConfig.Id=113;
      };
    };
    networks = {
      "20-br0-bind" = {
        matchConfig.Name = "enp38s0";
        # matchConfig.MACAddress = "00:d8:61:a6:97:17";
        networkConfig.Bridge = "br0";
      };
      "30-br0-ip" = {
        matchConfig.Name = "br0";
        # vlan = [ "vlan3" "vlan113" ];
        networkConfig = {
          DHCP = "ipv4";
          IPForward = "yes";
          MulticastDNS = "yes";
        };
        dhcpV4Config = {
          UseDNS = "yes";
          UseDomains = "yes";
        };
      };
      "30-vlan3-ip" = {
        matchConfig.Name="vlan3";
        networkConfig = {
          DHCP="ipv4";
          IPForward="yes";
          MulticastDNS="yes";
        };
        dhcpConfig.UseRoutes=false;
      };
      "30-vlan113-ip" = {
        matchConfig.Name="vlan113";
        networkConfig = {
          DHCP="ipv4";
          IPForward="yes";
          MulticastDNS="yes";
        };
        dhcpConfig.UseRoutes=false;
      };
    };
  };

  services.resolved.enable = true;
}
