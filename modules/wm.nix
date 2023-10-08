{pkgs, pkgs-unstable, ...}: {
  imports = [
    # hyprland.nixosModules.default
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
    ];
  };

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
        # defaultSession = "hyprland";
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      package = pkgs-unstable.hyprland;
      xwayland = {
        enable = true;
        hidpi = true;
      };
      nvidiaPatches = true;
    };
  };

  environment.systemPackages = with pkgs; [
    waybar
    swaybg
    swayidle
    swaylock
    wlogout
    wl-clipboard
    hyprpicker
    wf-recorder
    grim
    slurp
    mako
    yad
  ];
  # Is this needed?
  security.pam.services.swaylock = {};
}
