{
  lib,
  config,
  username,
  ...
}@args:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "cifs"
  ];

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users."${username}".openssh.authorizedKeys.keys;

  dino = {
    server = {
      enable = true;
      matrix.enable = true;
      grafana.enable = true;
    };
    git.enable = true;
  };

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    hostName = "venice";
    enableIPv6 = true;
  };

  system.stateVersion = "23.05";
}
