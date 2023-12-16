{ pkgs, ... }: {
  services.grafana = {
    enable = true;
    domain = "grafana.dinoocch.dev";
    port = 2342;
    addr = "0.0.0.0";
  };

  services.nginx.virtualHosts."grafana.dinoocch.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://[::]:2342$request_uri";
      proxyWebsockets = true;
    };
  };
}
