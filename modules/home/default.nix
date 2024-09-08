{
  lib,
  username,
  pkgs,
  ...
}:
let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf mkMerge;
in
{
  imports = [
    ../options.nix
    ./hyprland
    ./neovim
    ./catppuccin.nix
    ./darwin.nix
    ./dev.nix
    ./firefox.nix
    ./git.nix
    ./gtk.nix
    ./shells.nix
    ./spicetify.nix
    ./terminal.nix
    ./tmux.nix
    ./utils.nix
    ./wayland.nix
    ./wlogout.nix
    ./zellij.nix
  ];

  home = {
    inherit username;
    stateVersion = "23.05";
    homeDirectory = mkMerge [
      (mkIf stdenv.isDarwin "/Users/${username}")
      (mkIf (!stdenv.isDarwin) "/home/${username}")
    ];
  };
  programs.home-manager.enable = true;
  xdg.enable = true;
}
