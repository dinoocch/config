{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs; [
    pkgs-unstable.i3status-rust
    (pkgs.callPackage ../../../packages/i3-autolayout.nix {})
  ];

  xdg.configFile."i3/config".source = ./config;
}
