{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.dino.server.matrix;
  server_name = config.dino.server.domain;
  matrix_hostname = "matrix.${server_name}";

  # These ones you can leave alone

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/server`
  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "${matrix_hostname}:443"
    }
  '';

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/client`
  well_known_client = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://${matrix_hostname}"
      }
    }
  '';
in
{
  config = mkIf (config.dino.server.enable && cfg.enable) {
    services = {
      matrix-conduit = {
        enable = true;
        package = inputs.conduit.packages.${pkgs.system}.default;

        settings.global = {
          inherit server_name;

          allow_registration = false;
        };
      };

      nginx = {
        virtualHosts = {
          "${matrix_hostname}" = {
            forceSSL = true;
            enableACME = true;

            listen = [
              {
                addr = "0.0.0.0";
                port = 443;
                ssl = true;
              }
              {
                addr = "[::]";
                port = 443;
                ssl = true;
              }
            ];

            locations."/_matrix/" = {
              proxyPass = "http://backend_conduit$request_uri";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_buffering off;
              '';
            };

            extraConfig = ''
              merge_slashes off;
              access_log /var/log/nginx/matrix.dinoocch.dev.access.log json_combined;
            '';
          };

          "${server_name}" = {
            forceSSL = true;
            enableACME = true;

            locations."=/.well-known/matrix/server" = {
              alias = "${well_known_server}";

              extraConfig = ''
                # Set the header since by default NGINX thinks it's just bytes
                default_type application/json;
              '';
            };

            locations."=/.well-known/matrix/client" = {
              alias = "${well_known_client}";

              extraConfig = ''
                # Set the header since by default NGINX thinks it's just bytes
                default_type application/json;

                # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
                add_header Access-Control-Allow-Origin "*";
              '';
            };
          };
        };

        upstreams = {
          "backend_conduit" = {
            servers = {
              "[::1]:${toString config.services.matrix-conduit.settings.global.port}" = { };
            };
          };
        };
      };

      cfdyndns = {
        records = [ matrix_hostname ];
      };
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
