{pkgs, pkgs-unstable, catppuccin-starship, ...}: {
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
    };
    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };
    history = {
      size = 10000000;
    };
    defaultKeymap = "viins";
    initExtra = ''
      source "${pkgs-unstable.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh"
      zsh-defer source "${pkgs.skim}/share/skim/key-bindings.zsh"
      zsh-defer source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
      zsh-defer source "${pkgs.grc}/etc/grc.zsh"
    '';
  };

  programs.bash = {
    enable = true;
  };

}
