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
      ...
    }@inputs:
    {
      nixosConfigurations.stealth = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.brian = import ./home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
