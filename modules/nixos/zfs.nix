{
  config.nixos.modules.zfs = _: {
    boot.zfs.forceImportRoot = false;
    boot.kernelParams = [
      "elevator=none"
      "nohibernate"
    ];
    # TODO:
    # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    services.zfs.autoScrub.enable = true;
  };
}
