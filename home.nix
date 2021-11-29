{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.neovim-nightly

    pkgs.grc
    pkgs.starship
    pkgs.zsh-autopair
    pkgs.zsh-autosuggestions
    pkgs.zsh-completions
    pkgs.zsh-fast-syntax-highlighting
    pkgs.zsh-you-should-use

    pkgs.bat
    pkgs.exa
    pkgs.fd
    pkgs.htop
    pkgs.ripgrep
    pkgs.skim
    pkgs.tree

    pkgs.tmux
    pkgs.tmux-xpanes

    pkgs.deno
    pkgs.nodePackages.pyright
    pkgs.rust-analyzer
    pkgs.terraform-ls

    pkgs.rustup
  ];
}
