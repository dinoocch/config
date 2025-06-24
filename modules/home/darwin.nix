{ lib, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;

  mod = "cmd-ctrl-alt";
in
{
  config = mkIf stdenv.isDarwin {
    xdg.configFile = {
      "borders/bordersrc" = {
        text = ''
          #!/bin/bash

          options=(
            style=round
            width=6.0
            active_color=0xfff5c2e7
            inactive_color=0xff313244
          )

          borders "''${options[@]}"
        '';
        executable = true;
      };

      "aerospace/aerospace.toml" = {
        text = ''
          after-login-command = []
          after-startup-command = []
          start-at-login = true
          enable-normalization-flatten-containers = true
          enable-normalization-opposite-orientation-for-nested-containers = true

          accordion-padding = 30
          default-root-container-layout = 'tiles'
          default-root-container-orientation = 'auto'
          key-mapping.preset = 'qwerty'

          [gaps]
          inner.horizontal = 5
          inner.vertical =   5
          outer.left =       5
          outer.bottom =     5
          outer.top =        5
          outer.right =      5


          [exec]
          inherit-env-vars = true

          [exec.env-vars]
          PATH = '/opt/homebrew/bin:/opt/homebrew/sbin:''${PATH}'

          # 'main' binding mode declaration
          # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
          # 'main' binding mode must be always presented
          [mode.main.binding]
          ${mod}-enter = 'exec-and-forget open -n /Applications/Ghostty.app'
          ${mod}-slash = 'layout tiles horizontal vertical'
          ${mod}-comma = 'layout accordion horizontal vertical'

          ${mod}-h = 'focus left'
          ${mod}-j = 'focus down'
          ${mod}-k = 'focus up'
          ${mod}-l = 'focus right'
          ${mod}-shift-h = 'move left'
          ${mod}-shift-j = 'move down'
          ${mod}-shift-k = 'move up'
          ${mod}-shift-l = 'move right'

          ${mod}-shift-minus = 'resize smart -50'
          ${mod}-shift-equal = 'resize smart +50'

          ${mod}-1 = 'workspace 1'
          ${mod}-2 = 'workspace 2'
          ${mod}-3 = 'workspace 3'
          ${mod}-4 = 'workspace 4'
          ${mod}-5 = 'workspace 5'
          ${mod}-6 = 'workspace 6'
          ${mod}-7 = 'workspace 7'
          ${mod}-8 = 'workspace 8'
          ${mod}-9 = 'workspace 9'
          ${mod}-0 = 'workspace 10'
          ${mod}-a = 'workspace A'
          ${mod}-b = 'workspace B'
          ${mod}-c = 'workspace C'
          ${mod}-d = 'workspace D'
          ${mod}-e = 'workspace E'
          ${mod}-g = 'workspace G'
          ${mod}-i = 'workspace I'
          ${mod}-m = 'workspace M'
          ${mod}-n = 'workspace N'
          ${mod}-o = 'workspace O'
          ${mod}-p = 'workspace P'
          ${mod}-q = 'workspace Q'
          ${mod}-r = 'workspace R'
          ${mod}-s = 'workspace S'
          ${mod}-t = 'workspace T'
          ${mod}-u = 'workspace U'
          ${mod}-v = 'workspace V'
          ${mod}-w = 'workspace W'
          ${mod}-x = 'workspace X'
          ${mod}-y = 'workspace Y'
          ${mod}-z = 'workspace Z'

          ${mod}-shift-1 = 'move-node-to-workspace 1'
          ${mod}-shift-2 = 'move-node-to-workspace 2'
          ${mod}-shift-3 = 'move-node-to-workspace 3'
          ${mod}-shift-4 = 'move-node-to-workspace 4'
          ${mod}-shift-5 = 'move-node-to-workspace 5'
          ${mod}-shift-6 = 'move-node-to-workspace 6'
          ${mod}-shift-7 = 'move-node-to-workspace 7'
          ${mod}-shift-8 = 'move-node-to-workspace 8'
          ${mod}-shift-9 = 'move-node-to-workspace 9'
          ${mod}-shift-0 = 'move-node-to-workspace 10'
          ${mod}-shift-a = 'move-node-to-workspace A'
          ${mod}-shift-b = 'move-node-to-workspace B'
          ${mod}-shift-c = 'move-node-to-workspace C'
          ${mod}-shift-d = 'move-node-to-workspace D'
          ${mod}-shift-e = 'move-node-to-workspace E'
          ${mod}-shift-g = 'move-node-to-workspace G'
          ${mod}-shift-i = 'move-node-to-workspace I'
          ${mod}-shift-m = 'move-node-to-workspace M'
          ${mod}-shift-n = 'move-node-to-workspace N'
          ${mod}-shift-o = 'move-node-to-workspace O'
          ${mod}-shift-p = 'move-node-to-workspace P'
          ${mod}-shift-q = 'move-node-to-workspace Q'
          ${mod}-shift-r = 'move-node-to-workspace R'
          ${mod}-shift-s = 'move-node-to-workspace S'
          ${mod}-shift-t = 'move-node-to-workspace T'
          ${mod}-shift-u = 'move-node-to-workspace U'
          ${mod}-shift-v = 'move-node-to-workspace V'
          ${mod}-shift-w = 'move-node-to-workspace W'
          ${mod}-shift-x = 'move-node-to-workspace X'
          ${mod}-shift-y = 'move-node-to-workspace Y'
          ${mod}-shift-z = 'move-node-to-workspace Z'

          ${mod}-tab = 'workspace-back-and-forth'
          ${mod}-shift-tab = 'move-workspace-to-monitor --wrap-around next'
          ${mod}-f = 'fullscreen'

          # See: https://nikitabobko.github.io/AeroSpace/commands#mode
          ${mod}-shift-semicolon = 'mode service'

          # 'service' binding mode declaration.
          # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
          [mode.service.binding]
          esc = ['reload-config', 'mode main']
          r = ['flatten-workspace-tree', 'mode main'] # reset layout
          f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
          backspace = ['close-all-windows-but-current', 'mode main']

          ${mod}-shift-h = ['join-with left', 'mode main']
          ${mod}-shift-j = ['join-with down', 'mode main']
          ${mod}-shift-k = ['join-with up', 'mode main']
          ${mod}-shift-l = ['join-with right', 'mode main']

          [workspace-to-monitor-force-assignment]
          M = 3

          [[on-window-detected]]
          if.app-id = 'com.mitchellh.ghostty'
          run = [
            'layout tiling',
          ]

          [[on-window-detected]]
          if.app-id = 'com.spotify.client'
          run= 'move-node-to-workspace M'

          [[on-window-detected]]
          if.app-id = 'com.microsoft.teams2'
          run= 'move-node-to-workspace T'

          [[on-window-detected]]
          if.app-id = 'com.jetbrains.intellij'
          run= 'move-node-to-workspace I'
        '';
      };
    };
  };
}
