{ config, lib, ... }:
with lib;
let
  cfg = config.dino.server;
in
{
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      statusPage = true;

      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;
      recommendedZstdSettings = true;

      commonHttpConfig = ''
        log_format json_combined escape=json
          '{'
            '"time_local":"$time_local",'
            '"remote_addr":"$remote_addr",'
            '"remote_user":"$remote_user",'
            '"request":"$request",'
            '"status": "$status",'
            '"body_bytes_sent":"$body_bytes_sent",'
            '"request_time":"$request_time",'
            '"http_referrer":"$http_referer",'
            '"http_user_agent":"$http_user_agent"'
          '}';
        access_log /var/log/nginx/access.log json_combined;
      '';
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
