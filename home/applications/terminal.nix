{pkgs-unstable, ...}: {
  programs.alacritty = {
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

  programs.kitty = {
    enable = true;
    package = pkgs-unstable.kitty;
    settings = {
      font_family = "Comic Code Ligatures";
    };
  };

  programs.wezterm = {
    enable = true;
    package = pkgs-unstable.wezterm;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.font = wezterm.font("Comic Code Ligatures")
      config.color_scheme = "Catppuccin Mocha"
      config.webgpu_power_preference = "HighPerformance"
      return config
    '';
  };
}
