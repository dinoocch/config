{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = false;
    package = pkgs.firefox-wayland;
  };

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--force-dark-mode"
      "--gtk-version=4"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "-enable-features=VaapiVideoDecoder"
    ];
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--force-dark-mode"
      "--gtk-version=4"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "-enable-features=VaapiVideoDecoder"
    ];
  };
}
