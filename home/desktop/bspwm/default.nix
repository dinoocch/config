{ pkgs, pkgs-unstable, catppuccin-rofi, ... }: {
  home.packages = with pkgs; [
    nitrogen
    bspwm
    wmname
    sxhkd
    polybar
  ];

  xdg.configFile."bspwm/bspwmrc" = {
    executable = true;
    source = ./bspwmrc;
  };

  xdg.configFile."sxhkd/sxhkdrc".source = ./sxhkdrc;
  xdg.configFile."polybar/config.ini".source = ./polybar;
}
