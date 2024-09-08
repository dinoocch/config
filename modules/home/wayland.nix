{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dino.gui;
in
{
  config = mkIf (cfg.enable && cfg.isWayland) {
    # TODO: Are these even needed?
    home.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      MOZ_WEBRENDER = "1";
      QT_QPA_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_USE_LIBINPUT = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      __GL_VRR_ALLOWED = "1";
      __GL_GSYNC_ALLOWED = "1";
      __GL_MaxFramesAllowed = "1";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
      NVD_BACKEND = "direct";
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
      # XWAYLAND_NO_GLAMOR = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    home.packages = with pkgs; [
      pcmanfm
      grim
      hyprpicker
      slurp
      swayidle
      wf-recorder
      wl-clipboard
      waylock
      yad
    ];

    services = {
      mako = {
        enable = true;
        defaultTimeout = 5000;
      };
    };

    programs = {
      fuzzel.enable = true;
    };
  };
}
