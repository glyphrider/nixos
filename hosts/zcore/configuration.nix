{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network-configuration.nix
    ../optional/nfs-mounts-configuration.nix
  ];
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=\"1000:0072\""
  ];
  environment.systemPackages = [ pkgs.pciutils ];
}
