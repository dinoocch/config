{pkgs, username, hyprland, ...}: {
  services = {
    xserver.enable = false;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          command = "${hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
        };
      };
    };
  };

  security.pam.services.waylock = {};

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };
}
