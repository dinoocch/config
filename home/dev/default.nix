{username, ...}: {
  imports = [
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./utils.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
}
