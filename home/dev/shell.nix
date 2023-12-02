{pkgs, pkgs-unstable, catppuccin-starship, ...}: {
  home.packages = with pkgs; [
    bat
    fd
    htop
    ripgrep
  ];

  # programs.eza = {
  #  enable = true;
  #  enableAliases = true;
  #  package = pkgs-unstable.eza;
  # };
  programs.direnv.enable = true;

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

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      character = {
        success_symbol = "[[♥](green) ❯](sky)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
      };
      palette = "catppuccin_mocha";
    } // builtins.fromTOML (builtins.readFile "${catppuccin-starship}/palettes/mocha.toml");
  };
}
