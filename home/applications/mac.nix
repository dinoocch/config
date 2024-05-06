{ ... }: {
  xdg.configFile = {
    "borders/borderssrc" = {
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
      [gaps]
      inner.horizontal = 5;
      inner.vertical = 5;
      outer.left = 5;
      outer.right = 5;
      outer.top = 5;
      outer.bottom = 5;

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
