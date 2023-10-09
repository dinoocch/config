{pkgs, pkgs-unstable, config, catppuccin-qt5ct, ...}:
let
  theme = "Catppuccin-Mocha-Compact-Pink-Dark";
  qtct = ''
    [Appearance]
    color_scheme_path=${catppuccin-qt5ct}/themes/Catppuccin-Mocha.conf";
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=gtk3
    style=Fusion

    [Fonts]
    fixed="Comic Code Ligatures,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    general="Noto Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=2
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';
in {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xresources.properties = {
    "*.dpi" = 120;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-key-theme-name = theme;
    };
  };

  gtk = {
    enable = true;
    font = {
      # TODO: Comic Code?
      name = "Roboto";
      package = pkgs.roboto;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = theme;
      package = pkgs-unstable.catppuccin-gtk.override {
        accents = ["pink"];
        size = "compact";
        variant = "mocha";
      };
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "${theme}:dark";

  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = qtct;
    "qt6ct/qt6ct.conf".text = qtct;
  };
}
