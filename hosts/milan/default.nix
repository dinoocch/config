{config, username, ...} @ args:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/user-group.nix
    ../../modules/server.nix
  ];

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

  users.users.root.openssh.authorizedKeys.keys = config.users.users."${username}".openssh.authorizedKeys.keys;

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "milan";

    enableIPv6 = true;
    interfaces.enp2s0 = {
      useDHCP = true;
    };
    interfaces.enp3s0 = {
      useDHCP = false;
    };
    interfaces.enp4s0 = {
      useDHCP = false;
    };
    interfaces.enp5s0 = {
      useDHCP = false;
    };

    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  system.stateVersion = "23.05";
}
