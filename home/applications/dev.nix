{pkgs, ...}: {
  imports = [
    ./utils.nix
    ./git.nix
    ./zsh.nix
    ./fish.nix
    ./neovim
    ./zellij
  ];

  # TODO: probably none of these are needed with direnv
  home.packages = with pkgs; [
    gnumake
    gcc
    zig
    ast-grep
  ];

  programs.direnv.enable = true;
  programs.k9s.enable = true;
}
