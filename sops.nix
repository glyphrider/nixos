{ lib, pkgs, ... }:

let
  keyFile = "/var/lib/sops-nix/key.txt";
in
{
  # Decrypted with the NixOS module rather than sops-nix's home-manager one so
  # that it runs unattended at boot, using one age key shared by all hosts.
  # home.nix symlinks the SSH keys into ~/.ssh. They must never go through
  # home.file directly, which would put them in the world-readable Nix store.
  sops = {
    defaultSopsFile = ./secrets/ssh.yaml;
    age = {
      inherit keyFile;
      plugins = [ pkgs.age-plugin-yubikey ];
      # Stop sops-nix falling back to the SSH host keys it uses by default.
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
    secrets =
      lib.genAttrs
        [
          "ssh/id_ed25519"
          "ssh/id_ed25519_sk"
          "ssh/id_rsa"
          "ssh/id_rsa2048"
        ]
        (_: {
          owner = "brian";
          mode = "0400";
        })
      // {
        machine_key = { };
        aws_credentials = {
          sopsFile = ./secrets/aws.yaml;
          owner = "brian";
          mode = "0400";
        };
      };
  };

  # Lets a host with no machine key get one from a plain nixos-rebuild switch,
  # after which it no longer needs the YubiKey:
  #
  # 1. Bootstrap: point sops-nix at the YubiKey for this activation. Activation
  #    has no terminal, which is why the YubiKey's age identity has no PIN, only
  #    a touch. There's no pcscd during boot or nixos-install, so those skip this
  #    and log a sops error, and the host still boots with password login.
  # 2. setupSecrets decrypts everything, including machine_key.
  # 3. Install: copy machine_key to keyFile. sops-nix's own `path` option would
  #    only link it into /run/secrets, which is empty at the next boot, when the
  #    key is needed to decrypt /run/secrets in the first place. Comparing on
  #    every activation also rolls out a replaced machine key.
  #
  # Without the YubiKey, copying the offline backup key to keyFile and rebuilding
  # has the same result, since step 3 then replaces it with the machine key.
  system.activationScripts = {
    sopsMachineKeyBootstrap.text = ''
      if ! grep -qs '^AGE-SECRET-KEY-' ${keyFile} && [ -S /run/pcscd/pcscd.comm ]; then
        identity=$(timeout 10 ${pkgs.age-plugin-yubikey}/bin/age-plugin-yubikey --identity </dev/null 2>/dev/null || true)
        if [[ $identity == *AGE-PLUGIN-YUBIKEY-* ]]; then
          echo "sops-nix: no machine key yet, so using the YubiKey. Touch it when it blinks."
          mkdir -p ${dirOf keyFile}
          (umask 077; printf '%s\n' "$identity" >${keyFile})
        else
          echo "sops-nix: no machine key yet, and no YubiKey found." >&2
        fi
      fi
    '';

    setupSecrets.deps = [ "sopsMachineKeyBootstrap" ];

    sopsMachineKeyInstall = {
      deps = [ "setupSecrets" ];
      text = ''
        if [ -e /run/secrets/machine_key ] && ! ${pkgs.diffutils}/bin/cmp -s /run/secrets/machine_key ${keyFile}; then
          install -m 400 /run/secrets/machine_key ${keyFile}.tmp
          mv ${keyFile}.tmp ${keyFile}
          echo "sops-nix: installed ${keyFile}. The YubiKey is no longer needed to boot or rebuild."
        fi
      '';
    };
  };
}
