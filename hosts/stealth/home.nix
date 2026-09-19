# Host-specific home-manager config for `stealth`, layered on top of the
# shared ../../home.nix. Anything here is true for this physical desktop
# only — not for other hosts built from this flake.

{ pkgs, ... }:

{
  # Connects the Edifier speakers from the user session rather than from a
  # system service. A system-level service ran as soon as the bluetooth
  # adapter powered on at boot, which is before wireplumber (and its A2DP
  # media endpoints) exist for this user session -- bluetoothctl connect
  # either failed with "Protocol not available" or completed a bare ACL link
  # that never turned into a working audio stream, which showed up as a
  # connect-then-disconnect notification once the desktop appeared. So this
  # retry loop is scoped to the user session and ordered after wireplumber,
  # so it (re)tries once the A2DP endpoints actually exist -- including after
  # wireplumber restarts, e.g. across a suspend/resume cycle.
  systemd.user.services.edifier-bluetooth-autoconnect = {
    Unit = {
      Description = "Auto-connect Edifier bluetooth speakers (user session)";
      After = [ "wireplumber.service" ];
      PartOf = [ "wireplumber.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "edifier-bluetooth-connect-user" ''
        set -eu
        mac=64:68:76:70:F3:FE
        for i in $(seq 1 30); do
          if ${pkgs.bluez}/bin/bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            exit 0
          fi
          ${pkgs.bluez}/bin/bluetoothctl connect "$mac" && exit 0
          sleep 2
        done
        exit 1
      '';
    };
    Install = {
      WantedBy = [ "wireplumber.service" ];
    };
  };
}
