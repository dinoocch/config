{...}:
let
  server_name = "dinoocch.dev";
in
{
  imports = [
    ./acme.nix
  ];

  services.nginx.virtualHosts."rust.${server_name}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      # TODO: Build this with a flake...
      root = ./rust-intro;
    };
  };

  services.cfdyndns = {
    enable = true;
    email = "dino.occhialini@gmail.com";
    records = [
      "rust.${server_name}"
    ];
    # TODO: Create some private age encrypted secrets flake
    apikeyFile = "/etc/cfdns-token";
  };
}
