{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  config = {
    dino.zfs.enable = true;
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
    };

    system.stateVersion = "23.05";
  };
}
