{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = false;
    package = pkgs.firefox-wayland;
  };

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--gtk-version=4"
    ];
  };
}
