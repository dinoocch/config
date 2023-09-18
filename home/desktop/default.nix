{ pkgs, username, ... }: {
  # This could be more modular if I had a lot of computers needing different configs but I don't
  imports = [
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    packages = with pkgs; [
      discord

      # fluffy?
      element-desktop
    ];
  };

  programs.home-manager.enable = true;
}
