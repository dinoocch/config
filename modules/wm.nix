{pkgs, ...}: {
  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
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
    };
  };
}
