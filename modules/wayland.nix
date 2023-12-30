{username, pkgs-unstable, ...}: {
  services = {
    xserver.enable = false;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs-unstable.hyprland}/bin/Hyprland";
        };
      };
    };
  };

  security.pam.services.waylock = {};
}
