
{pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww".source = ./bar;
}
