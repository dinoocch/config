{pkgs, pkgs-unstable, catppuccin-hyprland, catppuccin-waybar, ...}: {
  imports = [
    ./eww
    ./i3
  ];
  systemd.user.sessionVariables = {
    MOZ_WEBRENDER = "1";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    pipewire
  ];
                                                                    }
