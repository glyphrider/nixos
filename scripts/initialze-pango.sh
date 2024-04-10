echo "enter luks passphrase"
read passphrase

parted /dev/nvme0n1 -- mktable gpt
parted /dev/nvme0n1 -- mkpart fat32 1M 512M
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart linux 512M 100%

echo $passphrase | cryptsetup luksFormat /dev/nvme0n1p2
echo $passphrase | cryptsetup open /dev/nvme0n1p2 nixos

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
