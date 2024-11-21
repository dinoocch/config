{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  inherit (pkgs) stdenv;
  # TODO: Surely there is some better option
  css =
    let
      base = "1e1e2e";
      mantle = "181825";
      surface0 = "313244";
      # surface1 = "45475a";
      # surface2 = "585b70";
      text = "cdd6f4";
      # rosewater = "f5e0dc";
      # lavender = "b4befe";
      red = "f38ba8";
      peach = "fab387";
      yellow = "f9e2af";
      green = "a6e3a1";
      # teal = "94e2d5";
      blue = "89b4fa";
      mauve = "cba6f7";
      flamingo = "f2cdcd";
    in
    # Based almost entirely on stylix base16 for now...will customize colors soon tm
    ''
      @define-color accent_color #${blue};
      @define-color accent_bg_color #${blue};
      @define-color accent_fg_color #${base};
      @define-color destructive_color #${red};
      @define-color destructive_bg_color #${red};
      @define-color destructive_fg_color #${base};
      @define-color success_color #${green};
      @define-color success_bg_color #${green};
      @define-color success_fg_color #${base};
      @define-color warning_color #${mauve};
      @define-color warning_bg_color #${mauve};
      @define-color warning_fg_color #${base};
      @define-color error_color #${red};
      @define-color error_bg_color #${red};
      @define-color error_fg_color #${base};
      @define-color window_bg_color #${base};
      @define-color window_fg_color #${text};
      @define-color view_bg_color #${base};
      @define-color view_fg_color #${text};
      @define-color headerbar_bg_color #${mantle};
      @define-color headerbar_fg_color #${text};
      @define-color headerbar_border_color rgba(24, 24, 37, 0.7);
      @define-color headerbar_backdrop_color @window_bg_color;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
      @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
      @define-color sidebar_bg_color #${mantle};
      @define-color sidebar_fg_color #${text};
      @define-color sidebar_backdrop_color @window_bg_color;
      @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
      @define-color secondary_sidebar_bg_color @sidebar_bg_color;
      @define-color secondary_sidebar_fg_color @sidebar_fg_color;
      @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
      @define-color secondary_sidebar_shade_color @sidebar_shade_color;
      @define-color card_bg_color #${mantle};
      @define-color card_fg_color #${text};
      @define-color card_shade_color rgba(0, 0, 0, 0.07);
      @define-color dialog_bg_color #${mantle};
      @define-color dialog_fg_color #${text};
      @define-color popover_bg_color #${mantle};
      @define-color popover_fg_color #${text};
      @define-color popover_shade_color rgba(0, 0, 0, 0.07);
      @define-color shade_color rgba(0, 0, 0, 0.07);
      @define-color scrollbar_outline_color #${surface0};
      @define-color blue_1 #${blue};
      @define-color blue_2 #${blue};
      @define-color blue_3 #${blue};
      @define-color blue_4 #${blue};
      @define-color blue_5 #${blue};
      @define-color green_1 #${green};
      @define-color green_2 #${green};
      @define-color green_3 #${green};
      @define-color green_4 #${green};
      @define-color green_5 #${green};
      @define-color yellow_1 #${yellow};
      @define-color yellow_2 #${yellow};
      @define-color yellow_3 #${yellow};
      @define-color yellow_4 #${yellow};
      @define-color yellow_5 #${yellow};
      @define-color orange_1 #${peach};
      @define-color orange_2 #${peach};
      @define-color orange_3 #${peach};
      @define-color orange_4 #${peach};
      @define-color orange_5 #${peach};
      @define-color red_1 #${red};
      @define-color red_2 #${red};
      @define-color red_3 #${red};
      @define-color red_4 #${red};
      @define-color red_5 #${red};
      @define-color purple_1 #${mauve};
      @define-color purple_2 #${mauve};
      @define-color purple_3 #${mauve};
      @define-color purple_4 #${mauve};
      @define-color purple_5 #${mauve};
      @define-color brown_1 #${flamingo};
      @define-color brown_2 #${flamingo};
      @define-color brown_3 #${flamingo};
      @define-color brown_4 #${flamingo};
      @define-color brown_5 #${flamingo};
      @define-color light_1 #${mantle};
      @define-color light_2 #${mantle};
      @define-color light_3 #${mantle};
      @define-color light_4 #${mantle};
      @define-color light_5 #${mantle};
      @define-color dark_1 #${mantle};
      @define-color dark_2 #${mantle};
      @define-color dark_3 #${mantle};
      @define-color dark_4 #${mantle};
      @define-color dark_5 #${mantle};
    '';
in

{
  config = mkIf (stdenv.isLinux && config.dino.gui.enable) {
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };

    xresources.properties = {
      "*.dpi" = 160;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;
      font = {
        name = "Roboto";
        package = pkgs.roboto;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };
    };

    xdg.configFile = {
      "gtk-3.0/gtk.css".text = css;
      "gtk-4.0/gtk.css".text = css;
    };
  };
}
