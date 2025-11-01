{ config, pkgs, ... }:
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;

    # This spawns a local valkey instance automatically.
    redisCreateLocally = false;

    settings = {
      server = {
        secret_key = "test";
        port = 8080;
        bind_address = "127.0.0.1";
      };
      search.formats = [ "html" "json" "rss" ];

      # Connect searxng to that local valkey instance.
      valkey.url = "valkey://localhost:6379/0";
    };
  };
}
