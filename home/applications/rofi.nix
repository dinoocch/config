{ pkgs, ... }: {
  home.packages = with pkgs; [
    rofi-power-menu
  ];

  programs.rofi = {
    enable = true;
    font = "Comic Code Ligatures 12";
    terminal = "kitty";
  };
}
