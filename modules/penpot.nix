{ config, lib, pkgs, options, ... }:
with lib;
let 
  server_name = "dinoocch.dev";
  PENPOT_ENV = {
    PUID = "1000";
    PGID = "996";
    TZ = "America/Los_Angeles";

    PENPOT_PUBLIC_URI = "https://pen.dinoocch.dev";
    PENPOT_TENANT = "pen";
    PENPOT_FLAGS = "enable-login";
    PENPOT_HTTP_SERVER_HOST = "127.0.0.1";
    PENPOT_DATABASE_URI = "postgresql://127.0.0.1:18935/penpot";

    # Probably could use secrets but it's fine
    PENPOT_DATABASE_USERNAME = "penpot";
    PENPOT_DATABASE_PASSWORD = "penpot";
    PENPOT_REDIS_URI = "redis://127.0.0.1:18936/0";
    PENPOT_ASSETS_STORAGE_BACKEND= "assets-fs";
    PENPOT_STORAGE_ASSETS_FS_DIRECTORY = "/opt/data/assets";
    PENPOT_TELEMETRY_ENABLED = "true";

    PENPOT_SMTP_ENABLED = "false";
    PENPOT_SMTP_DEFAULT_FROM = "no-reply@example.com";
    PENPOT_SMTP_DEFAULT_REPLY_TO = "no-reply@example.com";
  }; 
in 
{
  imports = [
    ./docker.nix
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      "penpot-frontend" = {
        autoStart = true;
        image = "penpotapp/frontend:latest";
        dependsOn = [
          "penpot-backend"
          "penpot-exporter"
        ];
        ports = [
          "10069:80"
        ];
        volumes = [
          "/var/cache/penpot/data:/opt/data"
        ];
        environmentFiles = [
          "/var/cache/penpot/config.env"
        ];
        extraOptions = [
          "--network=penpot"
        ];
      };
      "penpot-backend" = {
        autoStart = true;
        image = "penpotapp/backend:latest";
        dependsOn = [
          "penpot-postgres"
          "penpot-redis"
        ];
        volumes = [
          "/var/cache/penpot/data:/opt/data"
          "/var/cache/penpot/log4j2.xml:/opt/penpot/backend/log4j2.xml"
        ];
        environmentFiles = [
          "/var/cache/penpot/config.env"
        ];
        extraOptions = [
          "--network=penpot"
        ];
      };
      "penpot-exporter" = {
        autoStart = true;
        image = "penpotapp/exporter:latest";
        environment = {
          PENPOT_PUBLIC_URI = "http://penpot-frontend";
        };
        environmentFiles = [
          "/var/cache/penpot/config.env"
        ];
        extraOptions = [
          "--network=penpot"
        ];
      };
      "penpot-postgres" = {
        autoStart = true;
        image = "postgres:13";
        volumes = [
          "/var/cache/penpot/postgres/data:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_INITDB_ARGS = "--data-checksums";
          POSTGRES_DB = "penpot";
          POSTGRES_USER = "penpot";
          POSTGRES_PASSWORD = "penpot";
        };
        extraOptions = [
          "--network=penpot"
        ];
        cmd = [
          "-c"
          "log_statement=all"
        ];
      };
      "penpot-redis" = {
        autoStart = true;
        image = "redis:6";
        extraOptions = [
          "--network=penpot"
        ];
      };
    };
  };
  services.nginx.virtualHosts."pen.${server_name}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://[::]:10069$request_uri";
      proxyWebsockets = true;
    };
  };

  services.cfdyndns = {
    records = [
      "pen.${server_name}"
    ];
  };
}
