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
    services = {
      hyprpaper = {
        enable = true;
        settings = {
          preload = [
            "~/wallpapers/mocha-sword-girl.jpg"
            "~/wallpapers/mocha-japan-2-vscaled.png"
          ];
          wallpaper = [
            "DP-1,~/wallpapers/mocha-sword-girl.jpg"
            "DP-2,~/wallpapers/mocha-japan-2-vscaled.png"
          ];
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs-unstable.hyprland;
      settings = {
        exec-once = [
          "[workspace special:spotify silent] spotify"
          "[workspace special:discord silent] discord-canary"
          "waybar"
          "hyprpaper"
        ];

        monitor = [
          "DP-1,3840x2160@60,0x0,1.5"
          "DP-2,1920x1200@60,2560x0,1,transform,3"
          "Unknown-1,disable"
          ",preferred,auto,auto"
        ];

        input = {
          kb_layout = "us,us";
          follow_mouse = 2;
          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 12;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
        };

        cursor = {
          no_hardware_cursors = false;
          use_cpu_buffer = 0;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        xwayland = {
          force_zero_scaling = true;
        };

        misc = {
          vfr = false;
        };

        "$mod" = "SUPER";
        "$menu" = "fuzzel";

        bind =
          [
            "$mod, E, exec, pcmanfm"
            "$mod, T, exec, ghostty"
            "$mod, D, exec, fuzzel"

            "$mod SHIFT, Q, killactive"
            "$mod SHIFT, E, exec, wlogout"

            "$mod, V, togglefloating,"
            "$mod, P, pseudo,"
            "$mod, M, togglesplit"
            "$mod, F, fullscreen"

            "$mod, left, movefocus, l"
            "$mod, H, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, L, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, K, movefocus, u"
            "$mod, down, movefocus, d"
            "$mod, J, movefocus, d"

            "$mod SHIFT, left, movewindow, l"
            "$mod SHIFT, H, movewindow, l"
            "$mod SHIFT, right, movewindow, r"
            "$mod SHIFT, L, movewindow, r"
            "$mod SHIFT, up, movewindow, u"
            "$mod SHIFT, K, movewindow, u"
            "$mod SHIFT, down, movewindow, d"
            "$mod SHIFT, J, movewindow, d"
            "$mod, Tab, cyclenext,"
            "$mod, Tab, bringactivetotop,"

            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"

            "$mod, S, togglespecialworkspace, discord"
            "$mod SHIFT, S, togglespecialworkspace, spotify"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          ));

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindl = [
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ];

        windowrulev2 = [
          "workspace special:spotify, initialTitle:^(Spotify Premium)$"
          "workspace special:discord, class:^(discord)$"
          "workspace special:discord, class:^(vesktop)$"
        ];

        workspace = [
          "special:discord,gapsout:80"
          "special:spotify,gapsout:80"
        ];
      };
      # extraConfig = builtins.readFile ./hyprland.conf;
      systemd.enable = true;
    };
  };
}
