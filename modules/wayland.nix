{lib, pkgs, username, hyprland, ...}: let
  hyprland-pkgs = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  discord-flags = [
    "--flag-switches-begin"
    "--flag-switches-end"
    "--disable-gpu-memory-buffer-video-frames"
    "--enable-accelerated-mjpeg-decode"
    "--enable-accelerated-video"
    "--enable-gpu-rasterization"
    "--enable-native-gpu-memory-buffers"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"
    "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    "--ozone-platform=wayland"
    "--enable-webrtc-pipewire-capturer"
  ];
in  {
    services = {
      xserver.enable = false;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = username;
            command = "${hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
          };
        };
      };
    };

    security.pam.services.waylock = {};

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
    };
    hardware.opengl = {
      package = hyprland-pkgs.mesa.drivers;
      driSupport32Bit = true;
      package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
    };

    # TODO: Remove if it doesn't help at all and/or remove the duplication...
    environment.sessionVariables = {
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
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
  }
