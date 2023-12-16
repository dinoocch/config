{lib, config, username, ...} @ args:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/user-group.nix
    ../../modules/server.nix
    ../../modules/grafana.nix
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
    hostName = "venice";
    enableIPv6 = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };

  system.stateVersion = "23.05";
}
