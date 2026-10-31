{
  config.nixos.modules.home-assistant =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      hostname = "venice.${config.dino.server.domain}";
      zwaveSerialPort = "/dev/serial/by-id/usb-Zooz_800_Z-Wave_Stick_533D004242-if00";
      initialConfig = pkgs.writeText "home-assistant-configuration.yaml" ''
        automation: !include automations.yaml

        default_config:

        http:
          use_x_forwarded_for: true
          trusted_proxies:
            - 127.0.0.1
            - ::1
      '';
      zigbee2mqttConfig = pkgs.writeText "zigbee2mqtt-configuration.yaml" ''
        mqtt:
          server: mqtt://127.0.0.1:1883
          user: ha
          password: ha

        serial:
          port: tcp://192.168.2.164:6638
          baudrate: 115200
          adapter: ember
          disable_led: false

        advanced:
          transmit_power: 20

        frontend:
          enabled: true
          host: 127.0.0.1

        homeassistant:
          enabled: true
      '';
    in
    {
      age.secrets.zwave-js-keys = {
        file = ../../secrets/zwave-js-keys.age;
        mode = "0400";
      };
      virtualisation.oci-containers.containers = {
        zwave-js-ui = {
          image = "zwavejs/zwave-js-ui:latest";
          environment = {
            HOST = "0.0.0.0";
            PORT = "8091";
            ZWAVE_PORT = "/dev/zwave";
            ZWAVE_EXTERNAL_SETTINGS = "/run/secrets/zwave-js-keys.json";
          };
          volumes = [
            "/var/lib/zwave-js-ui:/usr/src/app/store"
            "${config.age.secrets.zwave-js-keys.path}:/run/secrets/zwave-js-keys.json:ro"
          ];
          devices = [ "${zwaveSerialPort}:/dev/zwave" ];
          extraOptions = [ "--network=host" ];
        };

        matter-server = {
          image = "ghcr.io/matter-js/python-matter-server:stable";
          cmd = [
            "--storage-path"
            "/data"
            "--paa-root-cert-dir"
            "/data/credentials"
            "--bluetooth-adapter"
            "0"
            "--primary-interface"
            "enp2s0"
          ];
          volumes = [
            "/var/lib/matter-server:/data"
            "/run/dbus:/run/dbus:ro"
          ];
          extraOptions = [
            "--network=host"
            "--security-opt=apparmor=unconfined"
          ];
        };

        zigbee2mqtt = {
          image = "koenkk/zigbee2mqtt:latest";
          environment.TZ = config.time.timeZone;
          volumes = [ "/var/lib/zigbee2mqtt:/app/data" ];
          extraOptions = [ "--network=host" ];
        };
      };

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
        "d /var/lib/matter-server 0750 root root -"
        "d /var/lib/zwave-js-ui 0750 root root -"
        "d /var/lib/zigbee2mqtt 0750 root root -"
        "C /var/lib/zigbee2mqtt/configuration.yaml 0644 root root - ${zigbee2mqttConfig}"
      ];

      # Use Cloudflare DNS-01 validation so no inbound HTTP(S) access is needed.
      security.acme.certs.${hostname} = {
        dnsProvider = "cloudflare";
        webroot = lib.mkForce null;
      };

      services = {
        mosquitto = {
          enable = true;
          listeners = [
            {
              address = "127.0.0.1";
              port = 1883;
              users.ha = {
                password = "ha";
                acl = [ "readwrite #" ];
              };
            }
          ];
        };

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
      };

      networking.firewall.allowedTCPPorts = [
        3000
        8091
      ];
      networking.firewall.allowedUDPPorts = [
        5353 # mDNS/Zeroconf discovery
        5540 # Matter
      ];
    };
}
