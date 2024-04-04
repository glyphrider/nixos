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
    };
    networks = {
      "20-br0-bind" = {
        matchConfig.Name = "enp39s0";
        networkConfig.Bridge = "br0";
      };
      "30-br0-ip" = {
        matchConfig.Name = "br0";
        # address = [ "192.168.47.252/24" ];
        # routes = [ { routeConfig.Gateway = "192.168.47.1"; } ];
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
    };
  };

  services.resolved.enable = true;
}
