{ config, lib, ... }:
with lib;
let
  cfg = config.dino.server;
in
{
  config = mkIf cfg.enable {
    virtualisation.containers.storage.settings = {
      storage = {
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };
  };
}
