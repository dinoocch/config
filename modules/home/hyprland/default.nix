{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
with lib;
let
  inherit (pkgs) stdenv;
  cfg = config.dino.gui;
in
{
  config = mkIf (cfg.enable && stdenv.isLinux && cfg.desktopEnvironment == "hyprland") {
    home.packages = with pkgs-unstable; [
      waybar
      hyprpaper
      playerctl
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs-unstable.hyprland;
      extraConfig = builtins.readFile ./hyprland.conf;
      systemd.enable = true;
    };

    xdg.configFile = {
      "hypr/waybar" = {
        source = ./waybar;
        recursive = true;
      };

      "hypr/hyprpaper.conf".text = ''
        # Wallpaper
        preload = ~/wallpapers/mocha-sword-girl.jpg
        preload = ~/wallpapers/mocha-japan-2-vscaled.png
        wallpaper = DP-1,~/wallpapers/mocha-sword-girl.jpg
        wallpaper = DP-2,~/wallpapers/mocha-japan-2-vscaled.png
      '';
    };
  };
}
