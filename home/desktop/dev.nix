# Most dev tools end up being in base
{pkgs, pkgs-unstable,...}: {
  imports = [
    ../dev 
  ];
  home.packages = with pkgs; [
    insomnia
  ];

  programs.gh = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    package = pkgs-unstable.wezterm;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.font = wezterm.font("JetBrainsMono Nerd Font")
      config.color_scheme = "Catppuccin Mocha"
      config.webgpu_power_preference = "HighPerformance"
      config.enable_wayland = false
      return config
    '';
  };
}
