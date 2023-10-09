{ pkgs, pkgs-unstable, catppuccin-rofi, ... }: {
  home.packages = with pkgs; [
    pkgs-unstable.i3status-rust
    rofi-power-menu
    (pkgs.callPackage ../../../packages/i3-autolayout.nix {})
  ];

  xdg.configFile."i3/config".source = ./config;
  xdg.configFile."i3status-rust/config.toml".source = ./i3status-rust.toml;

  xdg.dataFile.catppuccin-rofi = {
    source = catppuccin-rofi + "/basic/.local/share/rofi/themes";
    target = "rofi/themes";
    recursive = true;
  };

  programs.rofi = {
    enable = true;
    font = "Comic Code Ligatures 12";
    terminal = "kitty";
    theme = "catppuccin-mocha";
  };
}
