{ config, lib, ... }:
with lib;
let
  cfg = config.dino.zfs;
in
{
  config = mkIf cfg.enable {
    boot.kernelParams = [
      "elevator=none"
      "nohibernate"
    ];
    # TODO:
    # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    services.zfs.autoScrub.enable = true;
  };
}
