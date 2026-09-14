# Host-specific home-manager config for `stealth`, layered on top of the
# shared ../../home.nix. Anything here is true for this physical desktop
# only — not for other hosts built from this flake.

{ pkgs, ... }:

{
  # The system-level edifier-bluetooth-autoconnect service (hosts/stealth/configuration.nix)
  # connects the speakers as soon as the bluetooth adapter powers on at boot,
  # which is before wireplumber (and its A2DP media endpoints) exist for this
  # user session -- bluetoothctl connect either fails with "Protocol not
  # available" or completes a bare ACL link that never turns into a working
  # audio stream, which is what shows up as a connect-then-disconnect
  # notification once the desktop appears. Re-run the same retry loop here,
  # scoped to the user session and ordered after wireplumber, so it (re)tries
  # once the A2DP endpoints actually exist -- including after wireplumber
  # restarts, e.g. across a suspend/resume cycle.
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
