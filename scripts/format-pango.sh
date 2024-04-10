#!/usr/bin/env bash

mkfs.fat -F 32 /dev/nvme0n1p1

mkfs.brtrs /dev/mapper/nixos
mount /dev/mapper/nixos /mnt
for sub in @{,var,nix,home}; do
  btrfs subv create /mnt/$sub
done
umount /mnt
mount -o subvol=@ /dev/mapper/nixos

for sub in {var,nix,home}; do
  mount --mkdir -o subvol=@$sub /dev/mapper/nixos /mnt/$sub
done

mount --mkdir -o umask=0077 /dev/nvme0n1p1 /mnt/boot

nixos-generate-config --root /mnt
