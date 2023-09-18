{pkgs, hyprland, catppuccin-hyprland, ...}: {
  imports = [
    hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    mako
    grim
    pipewire
    # TODO: Switch to eww
    # eww-wayland
    waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = true;
  };

  xdg.configFile."hypr/themes".source = "${catppuccin-hyprland}/themes";
  xdg.configFile."waybar/mocha.css".source = "${catppuccin-waybar}/themes/mocha.css";

  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";

    # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
    "LIBVA_DRIVER_NAME" = "nvidia";
    "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_EGL_NO_MODIFIRES" = "1";
  };
}
