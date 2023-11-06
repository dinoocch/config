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

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
  };

  networking = {
    hostName = "milan";

    enableIPv6 = true;

    # WAN Port
    interfaces.enp2s0 = {
      useDHCP = true;
    };

    # Ports
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

    vlans = {
      wan = {
        id = 10;
        interface = "enp2s0";
      };
      lan = {
        id = 20;
        interface = "enp3s0";
      };
      wifi = {
        id = 30;
        interface = "enp4s0";
      };
      # TODO: This won't be used until I move into house lol
      iot = {
        id = 40;
        interface = "enp5s0";
      };
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Unbound DNS
  services.unbound = {
    enable = true;
    settings = {
      interface = [
        "127.0.0.1"
        "10.1.0.1"
        "10.2.0.1"
        "10.3.0.1"
      ];
      access-control = [
        "0.0.0.0/0 refuse"
        "127.0.0.0/8 allow"
        "10.0.0.0/8 allow"
      ];
    };
  };
  networking.firewall.interfaces = {

  };

  # TODO; Add miniupnpd if it ends up being too much of a hassle



  system.stateVersion = "23.05";
}
