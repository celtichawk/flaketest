{ config, pkgs, ... }:

{
  home.username = "jacek";
  home.homeDirectory = "/home/jacek";
  programs.home-manager.enable = true; 

  home.sessionVariables = {
    WINEPREFIX = "/home/jacek/games/wine";
    EDITOR = "mousepad";
  };

  # Everything piper-related (xdg.configFile) has been moved to piper.nix
  
  home.packages = [ ]; 

  programs.zsh = {
    enable = true;
    shellAliases = {
      nixswitch = "sudo nixos-rebuild switch --flake '/home/jacek/Documents/flaketest#tigers-desktop'";
      nixclean  = "sudo nix-collect-garbage -d";
    };
  };

  programs.direnv.enable = true;
  programs.zoxide.enable = false;
  nixpkgs.config.allowUnfree = true;
  
  # Keep this as your original install version (e.g., "23.11" or "24.11")
  home.stateVersion = "24.11"; 
}