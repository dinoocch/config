{
  config.homeManager.modules.base =
    {
      lib,
      username,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) stdenv;
      inherit (lib) mkIf mkMerge;

      extraPaths = [
        "~/.local/bin"
        "~/bin"
      ];
    in
    {
      home = {
        inherit username;
        stateVersion = "23.05";
        homeDirectory = mkMerge [
          (mkIf stdenv.isDarwin "/Users/${username}")
          (mkIf (!stdenv.isDarwin) "/home/${username}")
        ];

        sessionVariables = {
          PATH = "${lib.concatStringsSep ":" extraPaths}:$PATH";
        };
      };
      programs.home-manager.enable = true;
      xdg.enable = true;
    };

  config.nixos.modules.base =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.determinate.nixosModules.default ];

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
    };
}
