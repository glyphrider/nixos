default:
  @just --list

nixos:
  @sudo nixos-rebuild switch --flake .#`hostname`

boot:
  @sudo nixos-rebuild boot --flake .#`hostname`

home:
  @home-manager switch --flake .#`whoami`@`hostname`
