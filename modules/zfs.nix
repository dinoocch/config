{config, pkgs, ...}: {
  boot.kernelParams = [
    "elevator=none"
    "nohibernate"
  ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  services.zfs.autoScrub.enable = true;
}
