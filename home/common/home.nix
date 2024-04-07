{ config, pkgs, inputs, ... }:

{
  imports = [
    ./bash.nix
    ./vim.nix
    ./zsh.nix
  ];
}
