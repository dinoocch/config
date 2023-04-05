{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim-nightly
    tree-sitter

    grc
    starship
    zsh-autopair
    zsh-autosuggestions
    zsh-completions
    zsh-defer
    zsh-fast-syntax-highlighting
    zsh-you-should-use

    bat
    exa
    fd
    htop
    ripgrep
    skim
    tree
    gh
    gping

    tmux
    tmux-xpanes

    ctags
    deno
    pyright
    rnix-lsp
    # sumneko-lua-language-server
    terraform-ls
    kotlin-language-server
    gopls
    nodePackages.eslint_d
    codespell
    cppcheck
    nixfmt
    # nodePackages.prettierd
    # rustywind
    stylua
    black

    rustup
    rust-analyzer-nightly

    openjdk
    kotlin

    (luajit.withPackages (ps: with ps; [ pcre2 ]))
  ];

  home.file.".zshenv".source = ./files/zsh/zshenv;
  xdg.configFile."zsh" = {
    source = ./files/zsh/config;
    recursive = true;
  };
  # TODO: There's probably some clever way to do this
  home.file.".zshrc".text = ''
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

  xdg.configFile."nvim" = {
    source = ./files/nvim;
    recursive = true;
  };

  home.file.".gitconfig".source = ./files/git/gitconfig;
  home.file.".gitconfig-linkedin".source = ./files/git/gitconfig-linkedin;
  home.file.".gitignore".source = ./files/git/gitignore;

  home.file.".tmux.conf".source = ./files/tmux.conf;

  xdg.configFile."alacritty/alacritty.yml".source = ./files/alacritty.yml;
  xdg.configFile."wezterm/wezterm.lua".source = ./files/wezterm.lua;
  xdg.configFile."starship.toml".source = ./files/starship.toml;
}
