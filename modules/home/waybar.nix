{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  inherit (pkgs) stdenv;
  cfg = config.dino.gui;
in
{
  config = mkIf (cfg.enable && stdenv.isLinux && cfg.desktopEnvironment == "hyprland") {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          spacing = 0;
          height = 38;

          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "custom/playerctl" ];
          modules-right = [
            "memory"
            "cpu"
            "network"
            "clock"
            "tray"
          ];

          "hyprland/workspaces" = {
            all-outputs = false;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            format-icons = {
              "1" = "I";
              "2" = "II";
              "3" = "III";
              "4" = "IV";
              "5" = "V";
              "6" = "VI";
              "7" = "VII";
              "8" = "VIII";
              "9" = "IX";
              "10" = "X";
            };
          };

          "custom/playerctl" = {
            "format" = "{icon}  <span>{}</span>";
            "return-type" = "json";
            "max-length" = 55;
            "exec" = "${pkgs.playerctl}/bin/playerctl -a metadata --format '{\"text\": \"  {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
            "on-click-middle" = "${pkgs.playerctl}/bin/playerctl previous";
            "on-click" = "${pkgs.playerctl}/bin/playerctl play-pause";
            "on-click-right" = "${pkgs.playerctl}/bin/playerctl next";
            "format-icons" = {
              "Paused" = "<span foreground='#6dd9d9'></span>";
              "Playing" = "<span foreground='#82db97'></span>";
            };
          };

          memory.format = "{}% ";
          cpu.format = "{usage}% ";
          network = {
            interval = 5;
            format = "{icon} ";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-linked = "󰤩 ";
            format-ethernet = "󰈀 ";
            format-disconnected = "󰤮 ";
            format-alt = " {bandwidthUpBytes} |  {bandwidthDownBytes}";
            tooltip-format = " {ifname} via {gwaddr}";
          };
          clock = {
            tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
            format = " {:%H:%M}";
            format-alt = " {:%a %b %d, %G}";
          };

          tray = {
            spacing = 10;
          };
        };
      };
      style = ''
        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;

        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;

        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;

        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        * {
          font-family: "Comic Code Ligatures";
          font-size: 12pt;
          font-weight: bold;
          transition-property: background-color;
          transition-duration: 0.5s;
          border-radius: 0px;
        }
        @keyframes blink_red {
          to {
            background-color: rgb(242, 143, 173);
            color: rgb(26, 24, 38);
          }
        }
        .warning,
        .critical,
        .urgent {
          animation-name: blink_red;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        window#waybar {
          background-color: rgba(49, 50, 68, 0.5);
        }
        window > box {
          padding: 3px;
          padding-left: 8px;
        }
        #workspaces {
          padding-left: 0px;
          padding-right: 4px;
        }
        #workspaces button {
          padding: 2px 5px;
          background: transparent;
          border-bottom: 3px solid transparent;
          color: @lavender;
        }
        #workspaces button.active, #workspaces button.focused {
          color: @pink;
          border-bottom: 3px solid @pink;
        }
        #workspaces button.urgent {
          color: shade(@red, 0.9);
        }
        #workspaces button:hover {
          color: shade(@sky, 0.9);
          border-bottom: 3px solid @sky;
        }
        tooltip {
          background: rgb(48, 45, 65);
        }
        tooltip label {
          color: rgb(217, 224, 238);
        }

        #clock,
        #memory,
        #cpu,
        #network,
        #tray {
          padding: 0 10px;
        }

        #custom-playerctl {
          color: @text;
        }
        #memory {
          color: @flamingo;
        }
        #cpu {
          color: @peach;
        }
        #clock {
          color: @text;
        }
        #network {
          color: @sky;
        }
        #network.disconnected {
          color: @red;
        }
      '';
    };
  };
}
