{config, lib, pkgs, pkgs-unstable, ...}: {
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
      jack.enable = true;
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
