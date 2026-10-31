{ config, inputs, ... }:
{
  config = {
    nixos.modules.venice =
      { config, username, ... }:
      {
        imports = [ ./_hardware-configuration.nix ];

        boot = {
          supportedFilesystems = [
            "ext4"
            "btrfs"
            "xfs"
            "ntfs"
            "fat"
            "vfat"
            "exfat"
            "cifs"
          ];

          # Bootloader.
          loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.enable = true;
          };

          kernel.sysctl = {
            "net.ipv6.conf.enp2s0.accept_ra" = 2;
            "net.ipv6.conf.enp2s0.accept_ra_rt_info_max_plen" = 64;
          };
        };

        users.users.root.openssh.authorizedKeys.keys =
          config.users.users."${username}".openssh.authorizedKeys.keys;

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
        config.nixos.modules.home-assistant
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
