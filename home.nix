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
    # pkgs.zsh-defer
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

  home.file.".zshenv".source = ./files/zsh/zshenv;
  home.file.".config/zsh" = {
    source = ./files/zsh/config;
    recursive = true;
  };
  # TODO: There's probably some clever way to do this
  home.file.".zshrc".text = 
    ''
      bindkey -v
      export KEYTIMEOUT=25

      source ~/.config/zsh/aliases.zsh
      source ~/.config/zsh/alternatives.zsh
      source ~/.config/zsh/completion.zsh
      source ~/.config/zsh/history.zsh
      source ~/.config/zsh/opts.zsh
      source ~/.config/zsh/os.zsh
      source ~/.config/zsh/prompt.zsh

      if [ -e "$HOME/.volta" ]; then
          export VOLTA_HOME="$HOME/.volta"
          export PATH="$VOLTA_HOME/bin:$PATH"
      fi

      source "${pkgs.skim}/share/skim/key-bindings.zsh"
      source "${pkgs.zsh-autopair}/share/zsh/zsh-autopair"
      source "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
      source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
      source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    '';

  home.file.".config/nvim" = {
    source = ./files/nvim;
    recursive = true;
  };
}
