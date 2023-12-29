{pkgs, pkgs-unstable, spitetify-nix, ...}: {
  imports = [
    ./base.nix
    ../applications/browsers.nix
    ../applications/dev.nix
    ../applications/gtk.nix
    ../applications/insomnia.nix
    ../applications/nushell.nix
    ../applications/terminal.nix
    ../applications/spicetify.nix

    ../applications/bspwm
  ];

  home.packages = with pkgs; [
      lutris
      pkgs-unstable.steam
      pkgs-unstable.steam-run
      steamtinkerlaunch
      pkgs-unstable.discord-canary
      easyeffects
      pkgs-unstable.protontricks

      pkgs-unstable.element-desktop
      gimp
      krita
      vlc
      pkgs-unstable.zoom-us
  ];

  fonts.fontconfig.enable = true;
  services.udiskie.enable = true;
  services.easyeffects.enable = true;
}
