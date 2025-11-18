{
  description = "Your NixOS configuration with Home Manager and Flatpak";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flatpak module
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Home Manager (tracking master; can pin a release if you prefer)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... } @ inputs:
  let
    inherit (self) outputs;
  in
  {
    nixosConfigurations = {
      tigers-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };

        modules = [
          # Flatpak support
          nix-flatpak.nixosModules.nix-flatpak

          # Home Manager integration
          home-manager.nixosModules.home-manager

          # Your existing system modules
          ./searx-ng.nix
          ./configuration.nix

          # Home Manager user configuration (wrapper for home.nix)
          ./home-users.nix
        ];
      };
    };
  };
}
