{
  config,
  username,
  nixos-rk3588,
  ...
} @ args:
{
  imports = [
    {
      nixpkgs.crossSystem = {
        config = "aarch64-unknown-linux-gnu";
      };
    }

    "${nixos-rk3588}/modules/boards/orangepi5plus.nix"
    ../../modules/base.nix
    ../../modules/user-group.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = config.users.users."${username}".openssh.authorizedKeys.keys;

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

  networking = {
    hostName = "venice";
    wireless.enable = false;
    networkmanager.enable = false;

    interfaces.enP3p49s0 = {
      useDHCP = true;
    };
    nameservers = [
      "8.8.8.8"
    ];
  };

  system.stateVersion = "23.05";
}
