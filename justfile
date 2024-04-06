set positional-arguments

default:
  @just --list

nixos:
  @sudo nixos-rebuild switch --flake .#`hostname`

boot:
  @sudo nixos-rebuild boot --flake .#`hostname`

home:
  @home-manager switch --flake .#`whoami`@`hostname`

install host: generate
  @cp -v /mnt/etc/nixos/hardware-configuration.nix hosts/$1/
  @nixos-install --flake .#$1

generate:
  @nixos-generate-config --root /mnt
