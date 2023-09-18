{config, ...} @ args:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable binfmt emulation of aarch64-linux, this is required for cross compilation.
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    #"zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "cifs"
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "rome";
    wireless.enable = false;
    networkmanager.enable = true;

    enableIPv6 = true;
    interfaces.enp5s0 = {
      useDHCP = true;
    };
    defaultGateway = "192.168.5.201";
    nameservers = [
      # TODO: Once a router is configured use that instead
      "8.8.8.8"
    ];
  };

  virtualisation.docker.storageDriver = "btrfs";

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  system.stateVersion = "23.05";
}
