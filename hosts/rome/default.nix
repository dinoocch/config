{ config, ... }:
{
  config = {
    nixos.modules.rome = _: {
      imports = [ ./_hardware-configuration.nix ];

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

    nixos.hosts.rome = {
      nixosModules = [
        config.nixos.modules.base
        config.nixos.modules.zfs
        config.nixos.modules.desktop
        config.nixos.modules.nvidia
        config.nixos.modules.wayland
        config.nixos.modules.rome
      ];
      homeModule = {
        imports = [
          config.homeManager.modules.base
          config.homeManager.modules.dev
          config.homeManager.modules.git
          config.homeManager.modules.tmux
          config.homeManager.modules.zellij
          config.homeManager.modules.desktop
          config.homeManager.modules.hyprland
          config.homeManager.modules.waybar
          config.homeManager.modules.wayland
          config.homeManager.modules.wlogout
          config.homeManager.modules.spicetify
          config.homeManager.modules.terminal
          config.homeManager.modules.gtk
          config.homeManager.modules.rome
        ];
      };
    };
  };
}
