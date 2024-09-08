{ config, lib, ... }:
with lib;
let
  cfg = config.dino.server;
in
{
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
    };

    # Open firewall ports for HTTP, HTTPS, and Matrix federation
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [
      80
      443
    ];
  };
}
