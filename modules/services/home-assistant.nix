{
  config.nixos.modules.home-assistant =
    { config, pkgs, ... }:
    let
      hostname = "homeassistant.${config.dino.server.domain}";
      initialConfig = pkgs.writeText "home-assistant-configuration.yaml" ''
        default_config:

        http:
          use_x_forwarded_for: true
          trusted_proxies:
            - 127.0.0.1
            - ::1
      '';
    in
    {
      virtualisation.oci-containers.containers.homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        environment.TZ = config.time.timeZone;
        volumes = [
          "/var/lib/home-assistant:/config"
          "/run/dbus:/run/dbus:ro"
        ];
        extraOptions = [
          "--network=host"
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
        ];
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/home-assistant 0750 root root -"
        "C /var/lib/home-assistant/configuration.yaml 0644 root root - ${initialConfig}"
      ];

      services = {
        nginx.virtualHosts.${hostname} = {
          forceSSL = true;
          enableACME = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:8123";
            proxyWebsockets = true;
            extraConfig = "proxy_buffering off;";
          };

          extraConfig = ''
            access_log /var/log/nginx/${hostname}.access.log json_combined;
          '';
        };

        cfdyndns.records = [ hostname ];
      };
    };
}
