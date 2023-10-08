{pkgs, pkgs-unstable, catppuccin-hyprland, catppuccin-waybar, ...}: {
  imports = [
    ./eww
    ./i3
  ];

  systemd.user.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    pipewire
  ];
}
