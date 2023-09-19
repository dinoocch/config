{pkgs, pkgs-unstable, catppuccin-starship, ...}: {
  home.packages = with pkgs; [
    bat
    fd
    htop
    ripgrep
    skim
    tree
    pkgs-unstable.eza

    zsh
    pkgs-unstable.zsh-defer
    zsh-fast-syntax-highlighting
  ];

  programs.eza = {
    enable = true;
    enableAliases = true;
    package = pkgs-unstable.eza;
  }

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
  }

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
      source "${pkgs-unstable.zsh-defer}/share/zsh/plugins/zsh-defer/zsh-defer.plugin.zsh"
      zsh-defer source "${pkgs.skim}/share/skim/key-bindings.zsh"
      zsh-defer source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
      zsh-defer source "${pkgs.grc}/etc/grc.zsh"
    '';
  }

  programs.nushell {
    enable = true;
    configFile = ''
      let-env config = {
        show_banner: false
        table: {
          mode: rounded
          index_mode: always
          show_empty: true
        }
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "prefix"
          external: {
            enable: true
            max_results: 100
            completer: null
          }
        }
        file_size: {
          metric: true
          format: "auto"
        }
        bracketed_paste: true
        edit_mode: vi
        shell_integration: true
      }
    '';
  }
}
