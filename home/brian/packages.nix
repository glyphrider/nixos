{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    rustup # used to install a version of rust
  ];
}
