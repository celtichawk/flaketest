# 1. Add 'osConfig' to the arguments list here
{ config, pkgs, osConfig, ... }: 

{
  home.username = "jacek";
  home.homeDirectory = "/home/jacek";
  programs.home-manager.enable = true; 

  home.sessionVariables = {
    WINEPREFIX = "/home/jacek/games/wine";
    EDITOR = "mousepad";
  };

  home.packages = [ 
    (pkgs.pidgin.override {
      plugins = with pkgs.pidginPackages; [
        purple-discord
        purple-slack
      ];
    })
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      # 2. Use the osConfig variable to dynamically grab the hostname
      nixswitch = "sudo nixos-rebuild switch --flake '/home/jacek/Documents/flaketest#${osConfig.networking.hostName}'";
      nixclean  = "sudo nix-collect-garbage -d";
    };
  };

  programs.direnv.enable = true;
  programs.zoxide.enable = false;
#  nixpkgs.config.allowUnfree = true;
  
  home.stateVersion = "24.11"; 
}