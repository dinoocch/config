{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
    ../options.nix
    ./acme.nix
    ./catppuccin.nix
    ./cfdyndns.nix
    ./conduit.nix
    ./desktop.nix
    ./docker.nix
    ./grafana.nix
    ./loki.nix
    ./netboot.nix
    ./nginx.nix
    ./nvidia.nix
    ./prometheus.nix
    ./promtail.nix
    ./user-group.nix
    ./wayland.nix
    ./xorg.nix
    ./zfs.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot.enable = lib.mkDefault true;
    systemd-boot.configurationLimit = lib.mkDefault 10;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 1w";
  };

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = lib.mkDefault false;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.enable = lib.mkDefault true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      git
      ghostty.terminfo
      vim
    ];

    variables.EDITOR = "vim";

    shells = with pkgs; [
      fish
      bash
      zsh
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  virtualisation = {
    docker = {
      enable = true;
    };
    podman = {
      enable = true;
      # dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      # backend = "podman";
    };
  };

  # TODO: DNS entries in milan
  networking.extraHosts = ''
    10.1.1.1 milan
    10.1.1.69 rome
    10.1.1.80 venice
  '';
}
