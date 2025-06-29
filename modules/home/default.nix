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
    ./hyprland.nix
    ./neovim
    ./catppuccin.nix
    ./darwin.nix
    ./desktop.nix
    ./dev.nix
    ./firefox.nix
    ./git.nix
    ./gtk.nix
    ./shells.nix
    ./spicetify.nix
    ./terminal.nix
    ./tmux.nix
    ./utils.nix
    ./waybar.nix
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
