{pkgs, pkgs-unstable, ...}: {
  imports = [
    ./starship.nix
    ./tmux.nix
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    shellAliases = {
      sl = "ls";
      sudo = "sudo ";
      git-up = "cd $(git rev-parse --show-toplevel)";
    };
    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };
    history = {
      size = 10000000;
    };
    defaultKeymap = "viins";
    initExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      source "${pkgs-unstable.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh"
      zsh-defer source "${pkgs.skim}/share/skim/key-bindings.zsh"
      zsh-defer source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
      zsh-defer source "${pkgs.grc}/etc/grc.zsh"
      path=('/Users/docchial/.cargo/bin' $path)
      export PATH
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
    '';
  };

  programs.bash = {
    enable = true;
  };

}
