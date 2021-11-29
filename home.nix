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
    pkgs.gh

    pkgs.tmux
    pkgs.tmux-xpanes

    pkgs.ctags
    pkgs.deno
    pkgs.pyright
    pkgs.rnix-lsp
    pkgs.rust-analyzer
    pkgs.terraform-ls

    pkgs.rustup
  ];
}
