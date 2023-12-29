{pkgs, ...}: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./neovim
  ];

  # TODO: probably none of these are needed with direnv
  home.packages = with pkgs; [
    gnumake
    gcc
    zig
    ast-grep
  ];

  programs.direnv.enable = true;
}
