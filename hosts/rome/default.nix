{config, pkgs, ...} @ args:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable binfmt emulation of aarch64-linux, this is required for cross compilation.
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.kernelParams = [
    "elevator=none"
    "nohibernate"
  ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    # "zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "cifs"
  ];
  services.zfs.autoScrub.enable = true;

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "rome";
    hostId = "2c1a46a1";
    wireless.enable = false;
    networkmanager.enable = false;

    enableIPv6 = true;
    interfaces.enp7s0 = {
      useDHCP = true;
    };
    # defaultGateway = "192.168.5.201";
    nameservers = [
      # TODO: Once a router is configured use that instead
      "8.8.8.8"
    ];

    extraHosts = ''
      10.1.1.1 milan
      10.1.1.80 venice
    '';
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  system.stateVersion = "23.05";
}
