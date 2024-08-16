{username, ...}: {
  imports = [
    ../applications/catppuccin.nix
    ../applications/zsh.nix
    ../applications/git.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
  xdg.enable = true;
}
