{ config, lib, ... }:
with lib;
let
  cfg = config.dino.server;
in
{
  config = mkIf cfg.enable {
    services.cfdyndns = {
      enable = false;
      email = "dino.occhialini@gmail.com";
      records = [ cfg.domain ];
      # TODO: Create some private age encrypted secrets flake
      apikeyFile = "/etc/cfdns-token";
    };
  };
}
