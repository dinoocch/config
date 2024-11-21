{
  lib,
  config,
  pkgs-unstable,
  ...
}:
with lib;
{
  config = mkIf config.dino.gui.enable {
    programs = {
      alacritty = {
        enable = true;
        package = pkgs-unstable.alacritty;
        settings = {
          font = {
            normal = {
              family = "Comic Code Ligatures";
              style = "Regular";
            };
            bold = {
              family = "Comic Code Ligatures";
              style = "Bold";
            };
          };
        };
      };

      kitty = {
        enable = true;
        package = pkgs-unstable.kitty;
        settings = {
          font_family = "Comic Code Ligatures";
        };
      };

      wezterm = {
        enable = true;
        extraConfig = ''
          local wezterm = require("wezterm")
          local config = wezterm.config_builder()
          config.font = wezterm.font("Comic Code Ligatures")
          config.color_scheme = "Catppuccin Mocha"
          config.webgpu_power_preference = "HighPerformance"
          config.hide_tab_bar_if_only_one_tab = true
          return config
        '';
      };
    };
  };
}
