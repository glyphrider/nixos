{ config, lib, pkgs, ... }:

{
  networking.hostName = "pango"; # Define your hostname.
  networking.hostId = "b4f9dc90";
  networking.networkmanager.enable = true;
}
