{ config , pkgs , conduit , ... }:

let
  server_name = "dinoocch.dev";
  matrix_hostname = "matrix.${server_name}";
  admin_email = "dino@${server_name}";

  # These ones you can leave alone

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/server`
  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "${matrix_hostname}:8443"
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
  # Configure Conduit itself
  services.matrix-conduit = {
    enable = true;

    # This causes NixOS to use the flake defined in this repository instead of
    # the build of Conduit built into nixpkgs.
    package = conduit.packages.${pkgs.system}.default;

    settings.global = {
      inherit server_name;

      allow_registration = false;
    };
  };

  # Configure automated TLS acquisition/renewal
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = admin_email;
    };
  };

  # ACME data must be readable by the NGINX user
  users.users.nginx.extraGroups = [
    "acme"
  ];

  # Configure NGINX as a reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

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
          {
            addr = "0.0.0.0";
            port = 8448;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 8448;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 8443;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 8443;
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
        '';
      };

      "${server_name}" = {
        forceSSL = true;
        enableACME = true;

        locations."=/.well-known/matrix/server" = {
          # Use the contents of the derivation built previously
          alias = "${well_known_server}";

          extraConfig = ''
            # Set the header since by default NGINX thinks it's just bytes
            default_type application/json;
          '';
        };

        locations."=/.well-known/matrix/client" = {
          # Use the contents of the derivation built previously
          alias = "${well_known_client}";

          extraConfig = ''
            # Set the header since by default NGINX thinks it's just bytes
            default_type application/json;

            # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
            add_header Access-Control-Allow-Origin "*";
          '';
        };
      };

      "rust.${server_name}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = ./rust-intro;
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

  services.cfdyndns = {
    enable = true;
    email = "dino.occhialini@gmail.com";
    records = [
      server_name
      matrix_hostname
      "rust.${server_name}"
      "grafana.${server_name}"
    ];
    # TODO: Create some private age encrypted secrets flake
    apikeyFile = "/etc/cfdns-token";
  };

  # Open firewall ports for HTTP, HTTPS, and Matrix federation
  networking.firewall.allowedTCPPorts = [ 80 443 8448 8443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 8448 8443 ];
}
