# Host-specific system config for `stealth`, layered on top of the shared
# ../../configuration.nix. Anything here is true for this physical desktop
# only (peripherals, etc.) — not for other hosts built from this flake.

{ ... }:

{
  # Bluetooth itself is enabled in the shared configuration.nix; the Edifier
  # speakers next to this desktop are connected by
  # edifier-bluetooth-autoconnect in hosts/stealth/home.nix.
}
