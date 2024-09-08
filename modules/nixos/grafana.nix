{ config, lib, ... }:
with lib;
let
  cfg = config.dino.server;
  mkScrapeConfigs =
    configs:
    flip mapAttrsToList configs (
      k: v:
      let
        static_configs = flip map v.hostNames (name: {
          targets = [ "${name}:${toString v.port}" ];
          labels.alias = name;
        });
      in
      mkIf (static_configs != [ ]) (
        {
          inherit static_configs;
          job_name = k;
          scrape_interval = "30s";
        }
        // (removeAttrs v [
          "hostNames"
          "port"
        ])
      )
    );
in
{
  config = mkIf (cfg.enable && cfg.grafana.enable) {
    services = {
      grafana = {
        enable = true;
        domain = "grafana.dinoocch.dev";
        port = 2342;
        addr = "0.0.0.0";

        provision.datasources = {
          settings.datasources = [
            {
              name = "Prometheus localhost";
              url = "http://localhost:9001";
              type = "prometheus";
              isDefault = true;
            }
            {
              name = "loki";
              url = "http://localhost:3030";
              type = "loki";
            }
          ];
        };
      };

      nginx.virtualHosts."grafana.dinoocch.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://[::]:2342$request_uri";
          proxyWebsockets = true;
        };
      };

      cfdyndns = {
        records = [ "grafana.dinoocch.dev" ];
      };
      prometheus = {
        enable = true;
        port = 9001;

        scrapeConfigs = mkScrapeConfigs {
          node = {
            hostNames = [
              "venice"
              "rome"
              "milan"
            ];
            port = 9100;
          };

          nginx = {
            hostNames = [ "venice" ];
            port = 9113;
          };

          unbound = {
            hostNames = [ "milan" ];
            port = 9167;
          };
        };
      };
    };

    systemd.services.prometheus.serviceConfig.LimitNOFILE = 1024000;
  };
}
