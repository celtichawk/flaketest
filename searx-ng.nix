{ config, pkgs, ... }:
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = true;
    settings.server.secret_key = "test";
    settings.server.port = 8080;
    settings.server.bind_address = "127.0.0.1";
    settings.search.formats = ["html" "json" "rss"];
#    settings.valkey.url = "valkey://localhost:6379/0";
  };
}
