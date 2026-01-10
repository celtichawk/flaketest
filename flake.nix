{
  description = "Your integrated NixOS and Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      # This ensures home-manager uses the same version of nixpkgs as your system
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... } @ inputs: 
  let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      # This is your main desktop entry point
      tigers-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./searx-ng.nix
          ./configuration.nix

          # --- Integration Starts Here ---
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jacek = import ./home.nix;
            
            # This allows home.nix to access flake inputs (like for the wrapper script)
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }
          # --- Integration Ends Here ---
        ];
      };
    };

    # You can keep this for other machines or standalone use, 
    # but 'tigers-desktop' will now ignore this and use the version above.
    homeConfigurations = {
      "jacek@tigers-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home.nix ];
      };
    };
  };
}