# Host-specific system config for `beast`, layered on top of the shared
# ../../configuration.nix. Anything here is true for this physical desktop
# only — not for other hosts built from this flake.

{ ... }:

{
  # Bluetooth itself is enabled in the shared configuration.nix. Unlike
  # stealth, beast's Edifier speakers are wired via TOSLink (optical S/PDIF)
  # rather than Bluetooth, so there's no pairing/autoconnect step needed —
  # pipewire picks up the optical output like any other ALSA sink. See
  # hosts/stealth/home.nix's edifier-bluetooth-autoconnect for the Bluetooth
  # version this replaces.
}
