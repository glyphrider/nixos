{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Pinned before hyprwm/Hyprland#16140 ("workspace: refactor workspace
    # handling"), which dropped the numeric workspace `id` from hyprctl's
    # JSON in favor of `address`, breaking waybar's hyprland/workspaces
    # module (it shows only "0"). Unpin once waybar supports the new
    # address-based workspace identity.
    hyprland.url = "github:hyprwm/Hyprland/34eb03bd8da01024596c367fba66485a8c9b8ca7";
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:glyphrider/kickstart.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    # Not a flake itself — just the source tree; podsight.nix builds it into
    # a package since it isn't in nixpkgs.
    podsight = {
      url = "github:arsin305/podsight";
      flake = false;
    };
    silent-sddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvim-config,
      hyprland,
      hyprpaper,
      nur,
      silent-sddm,
      ...
    }@inputs:
    let
      # Both hosts share configuration.nix/home.nix almost entirely (same AMD
      # GPU, same Hyprland desktop); `monitors` is the one piece that varies
      # enough per physical machine to warrant a parameter rather than a
      # hosts/<name>/home.nix override. Everything else host-specific lives
      # under ./hosts/<name>/.
      mkHost =
        {
          hostname,
          monitors,
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix
            ./hosts/${hostname}/configuration.nix
            { networking.hostName = hostname; }
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.brian = {
                  imports = [
                    ./home.nix
                    ./hosts/${hostname}/home.nix
                  ];
                };
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs monitors; };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        stealth = mkHost {
          hostname = "stealth";
          monitors = [
            "DP-1"
            "HDMI-A-1"
          ];
        };
        nixie = mkHost {
          hostname = "nixie";
          monitors = [ "eDP-1" ];
        };
        # Two DP monitors are planned, but the real connector names (likely
        # DP-1 + DP-2) aren't known until the machine is live. "*" is
        # hyprpaper's documented wildcard (see WallpaperMatcher::isWildcard)
        # and paints the wallpaper on every connected monitor regardless of
        # name, so this doesn't need to be revisited once the real names are
        # known -- only switch to explicit names if per-monitor wallpapers
        # are ever wanted.
        beast = mkHost {
          hostname = "beast";
          monitors = [ "*" ];
        };
      };
    };
}
