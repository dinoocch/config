{ pkgs, pkgs-unstable, ... }: {
  imports = [
    ../xorg.nix
  ];

  home.packages = with pkgs; [
    pkgs-unstable.i3status-rust
    (pkgs.callPackage ../../../packages/i3-autolayout.nix {})
  ];

  xdg.configFile."i3/config".source = ./config;
  xdg.configFile."i3status-rust/config.toml".source = ./i3status-rust.toml;
}
