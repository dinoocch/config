{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # neovim-nightly
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
    /* deno */
    /* pyright */
    /* rnix-lsp */
    /* sumneko-lua-language-server */
    /* terraform-ls */
    /* kotlin-language-server */
    /* gopls */
    /* nodePackages.eslint_d */
    codespell
    /* cppcheck */
    /* nixfmt */
    # nodePackages.prettierd
    # rustywind
    /* stylua */
    /* black */

    # rustup
    # rust-analyzer-nightly

    /* openjdk */
    /* kotlin */

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

  xdg.configFile."alacritty/alacritty.yml".source = ./files/alacritty.yml;
  xdg.configFile."wezterm/wezterm.lua".source = ./files/wezterm.lua;
  xdg.configFile."starship.toml".source = ./files/starship.toml;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    aggressiveResize = true;
    historyLimit = 500000;
    keyMode = "vi";
    # mouse = true; # unsupported yet?
    newSession = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.tmux-thumbs
      { 
        plugin = tmuxPlugins.mkTmuxPlugin {
          pluginName = "catppuccin";
          version = "4e48b09";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "tmux";
            rev = "4e48b09a76829edc7b55fbb15467cf0411f07931";
            sha256 = "bXEsxt4ozl3cAzV3ZyvbPsnmy0RAdpLxHwN82gvjLdU=";
          };
        };
      }
    ];
    terminal = "screen-256color";
    extraConfig = ''
    set-option -g -q mouse on
    set-option -ga terminal-overrides ",xterm-256color:RGB"
    set-option -sg escape-time 10
    set -g @catppuccin_flavour 'mocha'
    set -g status-position top

    bind x kill-pane
    bind r source-file "$HOME/.config/tmux/tmux.conf"

    bind h split-window -h -c "#{pane_current_path}"
    bind v split-window -v -c "#{pane_current_path}"

    if-shell '[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]' \
      'unbind C-b;\
      set-option -g prefix C-a;\

    bind C-a send-prefix
    bind -n M-Right next-window; \
    bind -n M-Left previous-window; \
    bind -n M-t new-window "#{pane_current_path}"; \
    bind -n C-M-Left swap-window -t -1; \
    bind -n C-M-Right swap-window -t +1'
    if-shell '[ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]' \
    'bind -n S-Right next-window; \
    bind -n C-t new-window -c "#{pane_current_path}"; \
    bind -r C-h select-window -t :-
    bind -r C-l select-window -t :+
    bind C-s set-window-option synchronize-panes
    '';
  };

}
