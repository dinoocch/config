# Most dev tools end up being in base
{pkgs, ...}: {
  home.packages = with pkgs; [
    insomnia
  ];

  programs.gh = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.font = wezterm.font("Comic Code Ligatures")
      config.color_scheme = "Catppuccin Frappe"
      return config
    '';
  };
}
