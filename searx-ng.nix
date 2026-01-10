{ config, pkgs, lib, ... }:

{
  services.redis = {
    enable = true;
    package = pkgs.valkey;
    bind = "127.0.0.1";
    port = 6379;
  };

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = false;

    settings = {
      server = {
        secret_key = "change-this-secret";
        bind_address = "127.0.0.1";
        port = 8080;
      };

      search = {
        formats = [ "html" "json" "rss" ];
      };

      redis = {
        url = "redis://127.0.0.1:6379/0";
      };

      engines = [
        {
          name = "wikidata";
          disabled = true;
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
