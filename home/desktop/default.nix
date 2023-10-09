{ pkgs, pkgs-unstable, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  # This could be more modular if I had a lot of computers needing different configs but I don't
  imports = [
    ./browser.nix
    ./dev.nix
    ./wm.nix
    ./gtk.nix
    ./neovim
    spicetify-nix.homeManagerModule
  ];

  home = {
    packages = with pkgs; [
      lutris
      pkgs-unstable.steam
      pkgs-unstable.steam-run
      steamtinkerlaunch
      pkgs-unstable.discord-canary
      # spotify
      easyeffects

      # fluffy?
      pkgs-unstable.element-desktop
      gimp
      krita
      vlc
      pkgs-unstable.zoom-us
    ];
  };

  services.easyeffects.enable = true;
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin-mocha;
    colorScheme = "flamingo";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
    ];
  };
}
