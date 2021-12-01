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
    pkgs.zsh-defer
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
    pkgs.terraform-ls

    pkgs.rustup
    pkgs.rust-analyzer-nightly
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

      source "${pkgs.zsh-defer}/share/zsh/plugins/zsh-defer/zsh-defer.plugin.zsh"
      zsh-defer source "${pkgs.skim}/share/skim/key-bindings.zsh"
      zsh-defer source "${pkgs.zsh-autopair}/share/zsh/zsh-autopair"
      zsh-defer source "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
      zsh-defer source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
      zsh-defer source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      zsh-defer source "${pkgs.grc}/etc/grc.zsh"
    '';

  home.file.".config/nvim" = {
    source = ./files/nvim;
    recursive = true;
  };

  home.file.".gitconfig".source = ./files/git/gitconfig;
  home.file.".gitconfig-linkedin".source = ./files/git/gitconfig-linkedin;
  home.file.".gitignore".source = ./files/git/gitignore;

  home.file.".tmux.conf".source = ./files/tmux.conf;

  xdg.configFile."alacritty/alacritty.yml".source = ./files/alacritty.yml;
}
