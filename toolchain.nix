{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # 1. Add Fenix as an input
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fenix }: 
  let
    system = "x86_64-linux"; # Matches your desktop
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # This creates a shell where 'cargo' and 'rustc' are pre-compiled binaries
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        (fenix.packages.${system}.stable.withComponents [
          "cargo"
          "rustc"
          "rust-src"
          "clippy"
        ])
      ];
    };
  };
}
