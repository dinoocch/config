{ ... }: {
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
        # All possible keys:
        # - Letters.        a, b, c, ..., z
        # - Numbers.        0, 1, 2, ..., 9
        # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
        # - F-keys.         f1, f2, ..., f20
        # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
        #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
        # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
        #                   keypadMinus, keypadMultiply, keypadPlus
        # - Arrows.         left, down, up, right
        #
        # All possible modifiers: cmd, alt, ctrl, shift
        # All possible commands: https://nikitabobko.github.io/AeroSpace/commands
        #
        # You can uncomment this line to open up terminal with alt + enter shortcut
        # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
        # alt-enter = 'exec-and-forget open -n /System/Applications/Utilities/Terminal.app'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-slash = 'layout tiles horizontal vertical'
        alt-comma = 'layout accordion horizontal vertical'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = 'focus left'
        alt-j = 'focus down'
        alt-k = 'focus up'
        alt-l = 'focus right'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        alt-shift-h = 'move left'
        alt-shift-j = 'move down'
        alt-shift-k = 'move up'
        alt-shift-l = 'move right'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-shift-minus = 'resize smart -50'
        alt-shift-equal = 'resize smart +50'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        alt-1 = 'workspace 1'
        alt-2 = 'workspace 2'
        alt-3 = 'workspace 3'
        alt-4 = 'workspace 4'
        alt-5 = 'workspace 5'
        alt-6 = 'workspace 6'
        alt-7 = 'workspace 7'
        alt-8 = 'workspace 8'
        alt-9 = 'workspace 9'
        alt-0 = 'workspace 10'
        alt-a = 'workspace A'
        alt-b = 'workspace B'
        alt-c = 'workspace C'
        alt-d = 'workspace D'
        alt-e = 'workspace E'
        alt-f = 'workspace F'
        alt-g = 'workspace G'
        alt-i = 'workspace I'
        alt-m = 'workspace M'
        alt-n = 'workspace N'
        alt-o = 'workspace O'
        alt-p = 'workspace P'
        alt-q = 'workspace Q'
        alt-r = 'workspace R'
        alt-s = 'workspace S'
        alt-t = 'workspace T'
        alt-u = 'workspace U'
        alt-v = 'workspace V'
        alt-w = 'workspace W'
        alt-x = 'workspace X'
        alt-y = 'workspace Y'
        alt-z = 'workspace Z'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        alt-shift-1 = 'move-node-to-workspace 1'
        alt-shift-2 = 'move-node-to-workspace 2'
        alt-shift-3 = 'move-node-to-workspace 3'
        alt-shift-4 = 'move-node-to-workspace 4'
        alt-shift-5 = 'move-node-to-workspace 5'
        alt-shift-6 = 'move-node-to-workspace 6'
        alt-shift-7 = 'move-node-to-workspace 7'
        alt-shift-8 = 'move-node-to-workspace 8'
        alt-shift-9 = 'move-node-to-workspace 9'
        alt-shift-0 = 'move-node-to-workspace 10'
        alt-shift-a = 'move-node-to-workspace A'
        alt-shift-b = 'move-node-to-workspace B'
        alt-shift-c = 'move-node-to-workspace C'
        alt-shift-d = 'move-node-to-workspace D'
        alt-shift-e = 'move-node-to-workspace E'
        alt-shift-f = 'move-node-to-workspace F'
        alt-shift-g = 'move-node-to-workspace G'
        alt-shift-i = 'move-node-to-workspace I'
        alt-shift-m = 'move-node-to-workspace M'
        alt-shift-n = 'move-node-to-workspace N'
        alt-shift-o = 'move-node-to-workspace O'
        alt-shift-p = 'move-node-to-workspace P'
        alt-shift-q = 'move-node-to-workspace Q'
        alt-shift-r = 'move-node-to-workspace R'
        alt-shift-s = 'move-node-to-workspace S'
        alt-shift-t = 'move-node-to-workspace T'
        alt-shift-u = 'move-node-to-workspace U'
        alt-shift-v = 'move-node-to-workspace V'
        alt-shift-w = 'move-node-to-workspace W'
        alt-shift-x = 'move-node-to-workspace X'
        alt-shift-y = 'move-node-to-workspace Y'
        alt-shift-z = 'move-node-to-workspace Z'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = 'workspace-back-and-forth'
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'
        
        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-shift-semicolon = 'mode service'
        
        # 'service' binding mode declaration.
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        [mode.service.binding]
        esc = ['reload-config', 'mode main']
        r = ['flatten-workspace-tree', 'mode main'] # reset layout
        #s = ['layout sticky tiling', 'mode main'] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
        backspace = ['close-all-windows-but-current', 'mode main']
        
        alt-shift-h = ['join-with left', 'mode main']
        alt-shift-j = ['join-with down', 'mode main']
        alt-shift-k = ['join-with up', 'mode main']
        alt-shift-l = ['join-with right', 'mode main']

        [workspace-to-monitor-force-assignment]
        1 = 1
        10 = 3
        A = 3
        B = 3
        C = 3
        D = 3
      '';
    };
  };
}
