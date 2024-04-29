{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.ollama
  ];
}
