{config, pkgs, ... }:
{
home.username = "jacek";
home.homeDirectory = "/home/jacek";
home.sessionVariables = {
WINEPREFIX = "/home/harley/gamestuff64";
EDITOR = "mousepad";
};
programs.zoxide.enable = true;
programs.direnv= {
enable = true;
nix-direnv.enable = true;
};
programs.zsh = {
enable = true;
shellAliases = {
  nixswitch = "sudo nixos-rebuild switch --flake '/home/jacek/Documents/flaketest#tigers-desktop'";
  nixboot   = "sudo nixos-rebuild boot --flake '/home/jacek/Documents/flaketest#tigers-laptop'";
  nixclean  = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake '/home/jacek/Documents/flaketest#tigers-desktop'";
  hmu       = "home-manager switch --flake '/home/jacek/Documents/flaketest#jacek@tigers-desktop'";
hmupdate = "cd /home/jacek/Documents/flaketest && nix flake update && hmu";
};
};
programs.vscode = {
enable = false;
package = pkgs.vscode.fhsWithPackages (ps: with ps; [python3 dart flutter]);
};
nixpkgs.config.allowUnfree = true;
home.stateVersion = "25.11";
}

