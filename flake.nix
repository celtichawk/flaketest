{
  description = "Your integrated NixOS and Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; # This closes the inputs block correctly

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... } @ inputs: 
  let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      tigers-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./searx-ng.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jacek = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }
        ];
      };
    };

    homeConfigurations = {
      "jacek@tigers-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home.nix ];
      };
    };
  };
}