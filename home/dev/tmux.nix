{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    sensibleOnTop = true;
    aggressiveResize = true;
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
