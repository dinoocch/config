{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dino.gui;
in
{
  config = mkIf (cfg.enable && !cfg.isWayland) {
    services = {
      xserver = {
        enable = true;

        desktopManager = {
          xterm.enable = false;
        };

        displayManager = {
          defaultSession = "none+bspwm";
          lightdm.enable = false;
          gdm = {
            enable = true;
          };
        };

        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [
            i3blocks
            i3lock
            i3status
            i3-gaps
            feh
          ];
        };

        windowManager.bspwm = {
          enable = true;
        };

        libinput = {
          enable = true;
          mouse = {
            middleEmulation = false;
            disableWhileTyping = false;
          };
        };
      };
    };
  };
}
