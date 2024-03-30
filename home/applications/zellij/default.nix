{pkgs, ...}: {
  imports = [
    ../fish.nix
  ];

  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
