{config, lib, pkgs, pkgs-unstable, custom-fonts, ...}: {
  imports = [
    ./base.nix
    # ./fhs-fonts.nix
    ./wm.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    colmena
    pulseaudio
    alsa-utils
    mpd
    mpc-cli
    ncmpcpp
    xfce.thunar
    yad
    zig
    aria2
    sqlite
    wget

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

  environment.shells = with pkgs; [
    bash
    zsh
    nushell
  ];

  programs = {
    ssh.startAgent = true;
    dconf.enable = true;
    light.enable = true;
    # TODO: Do I even need thunar tbh?
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thuman-volman
    ];
    # gamemode.enable = true;

    # TODO: Figure out what is wrong with krisp...
    noisetorch.enable = true;
  };

  security.rtkit.enable = true;
  sound.enable = false;

  services = {
    printing.enable = true;
    flatpak.enable = true;
    dbus.packages = [pkgs.gcr];
    geoclue2.enable = true;
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
    pipewire = {
      enable = true;
      package = pkgs-unstable.pipewire;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
      wireplumber.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      material-design-icons
      font-awesome
      noto-fonts
      source-sans
      source-serif
      # custom-fonts
      pkgs-unstable.comic-code
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
          # TODO: Comic Code Ligatures
        ];
      })
    ];

    # TODO: Comic Code Ligatures
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
