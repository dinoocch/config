{config, pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "550.76";
      sha256_64bit = "sha256-2/wAmBNiePhX74FsV7j21LnCaubxMC/kAYMmf8kQt1s=";
      sha256_aarch64 = "sha256-LhiyYCUTFwqzUITK6CKIqxOQp62wG1RuKOuP0fTKoVk=";
      openSha256 = "sha256-RWaUXIr/yCRmX4yIyUxvBxrKCLKRKSi4lQJAYvrd2Kg=";
      settingsSha256 = "sha256-Lv95+0ahvU1+X/twzWWVqQH4nqq491ALigH9TVBn+YY=";
      persistencedSha256 = "sha256-rbgI9kGdVzGlPNEvaoOq2zrAMx+H8D+XEBah2eqZzuI=";
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
