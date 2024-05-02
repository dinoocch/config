{username, ...}: {
  imports = [
    ../applications/zsh.nix
    ../applications/git.nix
    ../applications/dev.nix
    ../applications/terminal.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "23.05";
  };
}
