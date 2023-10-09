{pkgs, pkgs-unstable, config, ...}: {
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
      gtk-key-theme-name = "Catppuccin-Mocha-Compact-Pink-Dark";
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
      name = "Catppuccin-Mocha-Compact-Pink-Dark";
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
}
