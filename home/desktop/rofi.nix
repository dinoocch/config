{ pkgs, catppuccin-rofi, ... }: {
  home.packages = with pkgs; [
    rofi-power-menu
  ];

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
