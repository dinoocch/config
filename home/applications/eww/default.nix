
{pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    eww
  ];

  xdg.configFile."eww".source = ./bar;
}
