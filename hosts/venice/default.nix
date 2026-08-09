{ config, inputs, ... }:
{
  config = {
    nixos.modules.venice =
      {
        config,
        username,
        ...
      }:
      {
        imports = [ ./_hardware-configuration.nix ];

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
      };

    colmena.hosts.venice = {
      nixosModules = [
        config.nixos.modules.base
        config.nixos.modules.prometheus
        config.nixos.modules.acme
        config.nixos.modules.domain
        config.nixos.modules.cfdyndns
        config.nixos.modules.docker
        config.nixos.modules.nginx
        config.nixos.modules.conduit
        config.nixos.modules.grafana
        config.nixos.modules.venice
      ];
      homeModule = {
        imports = [
          config.homeManager.modules.base
          config.homeManager.modules.git
          config.homeManager.modules.venice
        ];
      };
    };

  };
}
