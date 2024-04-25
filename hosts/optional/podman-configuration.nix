{ config, lib, pkgs, ...}:

{
  # Enable incus
  virtualisation.podman = {
    enable = true;
  };
}
