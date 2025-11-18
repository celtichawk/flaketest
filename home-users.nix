{
  home-manager.enable = true;

  home-manager.users.jacek = {
    imports = [ ./home.nix ];
  };
}
