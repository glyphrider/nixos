# Host-specific system config for `stealth`, layered on top of the shared
# ../../configuration.nix. Anything here is true for this physical desktop
# only (peripherals, etc.) — not for other hosts built from this flake.

{ ... }:

{
  # Edifier speakers live next to this desktop; see home.nix's
  # edifier-bluetooth-autoconnect (hosts/stealth/home.nix) for the retry
  # logic that actually connects them.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
}
