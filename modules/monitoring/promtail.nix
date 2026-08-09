{
  config.nixos.modules.promtail =
    { config, lib, ... }:
    let
      cfg = config.dino.promtail;
    in
    {
      options.dino.promtail = {
        lokiServer = lib.mkOption {
          type = lib.types.str;
          default = "10.1.1.80:3030";
        };
      };

      config.services.promtail = {
        enable = true;
        configuration = {
          server = {
            http_listen_port = 3031;
            grpc_listen_port = 0;
          };
          positions = {
            filename = "/tmp/positions.yaml";
          };
          clients = [ { url = "http://${cfg.lokiServer}/loki/api/v1/push"; } ];
          scrape_configs = [
            {
              job_name = "journal";
              journal = {
                max_age = "12h";
                labels = {
                  job = "systemd-journal";
                  host = "${config.networking.hostName}";
                };
              };
              relabel_configs = [
                {
                  source_labels = [ "__journal__systemd_unit" ];
                  target_label = "unit";
                }
              ];
            }
          ];
        };
      };
    };
}
