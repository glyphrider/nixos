{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bash.nix
    ./emacs.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
    ./zsh.nix
  ];
}
