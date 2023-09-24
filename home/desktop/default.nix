{ pkgs, username, spicetify-nix, ... }:
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
    spicetify-nix.homeManagerModule
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    packages = with pkgs; [
      lutris
      steam
      steam-run
      discord
      # spotify
      easyeffects

      # fluffy?
      element-desktop
      gimp
      vlc
      zoom-us
    ];
  };

  programs.home-manager.enable = true;
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
