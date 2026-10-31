{ config, ... }:
{
  config.nixos.modules.niri =
    { lib, pkgs-unstable, ... }:
    {
      imports = [
        config.nixos.modules.wayland
        config.nixos.modules.noctalia
      ];

      programs.niri = {
        enable = true;
        package = pkgs-unstable.niri;
        useNautilus = false;
      };
      services.displayManager.defaultSession = lib.mkDefault "niri";
      environment.systemPackages = [ pkgs-unstable.xwayland-satellite ];
    };

  config.homeManager.modules.niri =
    {
      lib,
      pkgs,
      pkgs-unstable,
      ...
    }:
    let
      noctalia = lib.getExe pkgs-unstable.noctalia;
      niriConfig = pkgs.writeText "niri-config.kdl" ''
        input {
          keyboard { xkb { layout "us"; }; }
          touchpad { tap; natural-scroll; }
        }

        layout {
          gaps 12
          background-color "#1e1e2e"
          default-column-width { proportion 0.5; }
          focus-ring {
            width 2
            active-color "#f5c2e7"
            inactive-color "#585b70"
          }
          border { off; }
        }

        overview { backdrop-color "#181825"; }
        prefer-no-csd
        screenshot-path null

        window-rule {
          geometry-corner-radius 10
          clip-to-geometry true
        }
        window-rule {
          match app-id="dev.noctalia.Noctalia"
          open-floating true
        }
        debug { honor-xdg-activation-with-invalid-serial; }

        binds {
          Mod+T { spawn "${lib.getExe pkgs-unstable.ghostty}"; }
          Mod+E { spawn "${lib.getExe pkgs.pcmanfm}"; }
          Mod+D { spawn "${noctalia}" "msg" "panel-toggle" "launcher"; }
          Mod+S { spawn "${noctalia}" "msg" "panel-toggle" "control-center"; }
          Mod+Shift+E { spawn "${noctalia}" "msg" "panel-toggle" "session"; }
          Super+Alt+L { spawn "${noctalia}" "msg" "session" "lock"; }
          Mod+Shift+Q { close-window; }
          Mod+F { fullscreen-window; }
          Mod+V { toggle-window-floating; }
          Mod+R { switch-preset-column-width; }
          Mod+Tab { toggle-overview; }
          Mod+H { focus-column-left; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+L { focus-column-right; }
          Mod+Left { focus-column-left; }
          Mod+Down { focus-window-down; }
          Mod+Up { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+Shift+H { move-column-left; }
          Mod+Shift+J { move-window-down; }
          Mod+Shift+K { move-window-up; }
          Mod+Shift+L { move-column-right; }
          Mod+Page_Down { focus-workspace-down; }
          Mod+Page_Up { focus-workspace-up; }
          Mod+Shift+Page_Down { move-column-to-workspace-down; }
          Mod+Shift+Page_Up { move-column-to-workspace-up; }
          Print { screenshot; }
          XF86AudioRaiseVolume allow-when-locked=true { spawn "${noctalia}" "msg" "volume-up"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "${noctalia}" "msg" "volume-down"; }
          XF86AudioMute allow-when-locked=true { spawn "${noctalia}" "msg" "volume-mute"; }
          XF86AudioMicMute allow-when-locked=true { spawn "${noctalia}" "msg" "mic-mute"; }
          XF86AudioPlay allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioNext allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "next"; }
          XF86AudioPrev allow-when-locked=true { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
          XF86MonBrightnessUp allow-when-locked=true { spawn "${noctalia}" "msg" "brightness-up"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "${noctalia}" "msg" "brightness-down"; }
        }
      '';
    in
    {
      imports = [
        config.homeManager.modules.wayland
        config.homeManager.modules.noctalia
      ];

      config = lib.mkIf pkgs.stdenv.isLinux {
        home.packages = [ pkgs-unstable.ghostty ];
        xdg.configFile."niri/config.kdl".source = pkgs.runCommand "niri-config.kdl" { } ''
          ${lib.getExe pkgs-unstable.niri} validate --config ${niriConfig}
          cp ${niriConfig} $out
        '';
      };
    };
}
