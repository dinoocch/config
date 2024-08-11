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

    # ../applications/bspwm
    ../applications/hyprland
  ];

  home.packages = with pkgs; [
    pkgs-unstable.lutris
    pkgs-unstable.steam
    pkgs-unstable.steam-run
    steamtinkerlaunch
    pkgs-unstable.discord-canary
    pkgs-unstable.vesktop
    easyeffects
    pkgs-unstable.protontricks

    pkgs-unstable.element-desktop
    ardour
    audacity
    gimp
    krita
    vlc
    pkgs-unstable.zoom-us
    pkgs-unstable.vscode
    pkgs-unstable.ollama
  ];

  fonts.fontconfig.enable = true;
  services.udiskie.enable = true;
  services.easyeffects.enable = true;
}
