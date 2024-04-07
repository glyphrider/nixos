{ config, pkgs, inputs, ... }:

{
  imports = [
    ./bash.nix
    ./eza.nix
    ./font-config.nix
    ./fzf.nix
    ./vim.nix
    ./zsh.nix
  ];
}
