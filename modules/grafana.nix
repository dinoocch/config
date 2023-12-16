{ pkgs, lib, ... }:

with lib;

let
  mkScrapeConfigs = configs: flip mapAttrsToList configs (k: v:
  let
    static_configs = flip map v.hostNames (name: {
      targets = [ "${name}:${toString v.port}" ];
      labels.alias = name;
    });
  in
  (mkIf (static_configs != []) ({
    inherit static_configs;
    job_name = k;
    scrape_interval = "30s";
  } // (removeAttrs v [ "hostNames" "port" ]))));
in {
  services.grafana = {
    enable = true;
    domain = "grafana.dinoocch.dev";
    port = 2342;
    addr = "0.0.0.0";

    provision.datasources = {
      settings.datasources =
        [
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

  services.nginx.virtualHosts."grafana.dinoocch.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://[::]:2342$request_uri";
      proxyWebsockets = true;
    };
  };

  systemd.services.prometheus.serviceConfig.LimitNOFILE = 1024000;
  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = (mkScrapeConfigs ({
      node = {
        hostNames = [ "venice" "rome" "milan" ];
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
    }));
  };

  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3030;
      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "0.0.0.0";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };

      schema_config = {
        configs = [{
          from = "2022-06-06";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };

        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      chunk_store_config = {
        max_look_back_period = "0s";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };
}
