{
  config,
  lib,
  pkgs-unstable,
  ...
}:
with lib;
let
  cfg = config.dino.gui;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      lutris
      steam
      steam-run
      steamtinkerlaunch
      discord-canary
      vesktop
      protontricks
      element-desktop
      audacity
      gimp
      krita
      vlc
      zoom-us
      vscode
    ];

    fonts.fontconfig.enable = true;
    services.udiskie.enable = true;
    services.easyeffects.enable = true;
  };
}
