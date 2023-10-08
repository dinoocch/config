{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs; [
    pkgs-unstable.i3status-rust
  ];

  xdg.configFile."i3/config".source = ./config;
}
