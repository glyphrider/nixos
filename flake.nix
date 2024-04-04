{
  description = "Comprehensive Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprland-plugins }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { system = "${system}"; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      beast = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/core/configuration.nix
          ./hosts/beast/configuration.nix
          ./hosts/optional/zfs-grub-configuration.nix
          ./hosts/optional/nfs-mounts-configuration.nix
          ./hosts/optional/libvirtd-configuration.nix
        ];
      };
      pango = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/core/configuration.nix
          ./hosts/pango/configuration.nix
          ./hosts/optional/nfs-mounts-configuration.nix
          ./hosts/optional/lxd-configuration.nix
      };
    };
    homeConfigurations."brian" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [ ./home/brian/home.nix ];
    };
  };
}
