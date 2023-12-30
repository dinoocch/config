{pkgs-unstable, catppuccin-hyprland, ...}: {
  imports = [
    ../wayland.nix
  ];

  home.packages = with pkgs-unstable; [
    waybar
    hyprpaper
    playerctl
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
    settings = {
      source = "${catppuccin-hyprland}/themes/mocha.conf";
    };
    extraConfig = builtins.readFile ./hyprland.conf;
    systemd.enable = true;
  };

  xdg.configFile = {
    "hypr/waybar" = {
      source = ./waybar;
      recursive = true;
    };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    # Wallpaper
    preload = ~/wallpapers/japan-1-hscaled.png
    preload = ~/wallpapers/japan-2-vscaled.png
    wallpaper = DP-1,~/wallpapers/japan-1-hscaled.png
    wallpaper = DP-2,~/wallpapers/japan-2-vscaled.png
  '';
}
