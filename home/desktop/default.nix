{ pkgs, username, ... }: {
  # This could be more modular if I had a lot of computers needing different configs but I don't
  imports = [
    ./browser.nix
    ./dev.nix
    ./wm.nix
    ./gtk.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    packages = with pkgs; [
      lutris
      steam
      steam-run
      discord
      spotify

      # fluffy?
      element-desktop
    ];
  };

  programs.home-manager.enable = true;
}
