{lib, pkgs, ...}: {
  imports = [
    ./user-group.nix
  ];

  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 1w";
  };

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config.allowUnfree = lib.mkDefault false;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.enable = lib.mkDefault true;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
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

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    aria2

    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = ["dev"];
          })
    )
  ];

  environment.variables.EDITOR = "nvim";

  environment.shells = with pkgs; [
    bash
    zsh
    nushell
  ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
}
