{pkgs-unstable, ...}: {
  imports = [
    ../wayland.nix
    ../wlogout.nix
  ];

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

  programs = {
    fuzzel = {
      enable = true;
    };
    tofi = {
      enable = true;
    };
  };
}
