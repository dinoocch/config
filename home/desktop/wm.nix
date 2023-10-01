{pkgs, pkgs-unstable, catppuccin-hyprland, catppuccin-waybar, ...}: {
  imports = [
    # hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    mako
    grim
    pipewire
    # TODO: Switch to eww
    # eww-wayland
    waybar
    wofi
    pkgs-unstable.swww
    pkgs-unstable.hyprpaper
  ];

  xdg.configFile."hypr/themes".source = "${catppuccin-hyprland}/themes";
  xdg.configFile."waybar/mocha.css".source = "${catppuccin-waybar}/themes/mocha.css";

  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_EGL_NO_MODIFIRES = "1";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
  };
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Monitors
    monitor=DP-1,3840x2160@60,0x0,1
    monitor=DP-2,1920x1200@60,3840x0,1,transform,1
    # debug:overlay = true

    # Fix slow startup
    exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 

    # Autostart
    exec-once = mako
    exec-once = hyprpaper
    exec = pkill waybar & sleep 0.5 && waybar
    exec-once = ${pkgs-unstable.hyprdim}/bin/hyprdim --no-dim-when-only --persist --ignore-leaving-special --dialog-dim

    input {
        follow_mouse = 0
    }

    general {
        gaps_in = 5
        gaps_out = 20
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
        layout = dwindle
    }

    decoration {
        rounding = 10
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = yes
        bezier = ease,0.4,0.02,0.21,1
        animation = windows, 1, 3.5, ease, slide
        animation = windowsOut, 1, 3.5, ease, slide
        animation = border, 1, 6, default
        animation = fade, 1, 3, ease
        animation = workspaces, 1, 3.5, ease
    }

    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    master {
        new_is_master = yes
    }

    gestures {
        workspace_swipe = false
    }

    $mainMod = SUPER
    bind = $mainMod, G, fullscreen,

    bind = $mainMod, RETURN, exec, alacritty
    bind = $mainMod, B, exec, firefox
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, F, exec, thunar
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, W, exec, wofi --show drun

    bind = SUPER,Tab,cyclenext,
    bind = SUPER,Tab,bringactivetotop,

    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    bindm = ALT, mouse:272, resizewindow
  '';

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    # Wallpaper
    preload = ~/wallpapers/japan-1-hscaled.png
    preload = ~/wallpapers/japan-2-vscaled.png
    wallpaper = DP-1,~/wallpapers/japan-1-hscaled.png
    wallpaper = DP-2,~/wallpapers/japan-2-vscaled.png
  '';
}
