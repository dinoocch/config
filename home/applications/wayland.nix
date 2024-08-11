{pkgs, ...}: {
  # Wayland environment variables are such a drag
  home.sessionVariables = {
    # Most likely not needed, but force nvidia gbm
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Force wayland for ozone (electron) apps
    NIXOS_OZONE_WL = "1";

    # Nvidia hardware acceleration
    LIBVA_DRIVER_NAME = "nvidia";

    # Set wayland for various apps
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MOZ_WEBRENDER = "1";
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";

    # A few weird wayland things
    WLR_DRM_NO_ATOMIC = "1";
    WLR_USE_LIBINPUT = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";

    # A few weird nvidia things
    __GL_VRR_ALLOWED = "1";
    __GL_GSYNC_ALLOWED = "1";
    __GL_MaxFramesAllowed = "1";
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    # Something weird for proton nvidia updates
    PROTON_ENABLE_NGX_UPDATER = "1";

    # Direct video decoding seems poggers
    NVD_BACKEND = "direct";

    # I don't use prime/optimus but it's fine
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __VK_LAYER_NV_optimus = "NVIDIA_only";

    # TODO
    # XWAYLAND_NO_GLAMOR = "1";
  };

  home.packages = with pkgs; [
    dolphin
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
      # ignoreTimeout = true;
      defaultTimeout = 5000;
    };
  };
}
