# Most dev tools end up being in base
{pkgs, pkgs-unstable, custom-fonts, catppuccin-starship, catppuccin-alacritty, ...}: {
  imports = [
    ../dev 
  ];
  home.packages = with pkgs; [
    insomnia
    pkgs-unstable.zsh-defer
    pkgs-unstable.eza
    zsh-fast-syntax-highlighting
    skim
    tree
    zsh
    gnumake
    gcc
    sad
    jq
    gnupg
    zstd
    unzip
    nix-output-monitor
    ast-grep
  ];

  programs.gh = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty;
    settings = {
      font = {
        normal = {
          family = "Comic Code Ligatures";
          style = "Regular";
        };
        bold = {
          family = "Comic Code Ligatures";
          style = "Bold";
        };
      };
      import = [
        "${catppuccin-alacritty}/catppuccin-mocha.yml"
      ];
    };
  };

  programs.kitty = {
    enable = true;
    package = pkgs-unstable.kitty;
    theme = "Catppuccin-Mocha";
    settings = {
      font_family = "Comic Code Ligatures";
    };
    # font = "Comic Code Ligatures";
    # font = pkgs-unstable.comic-code;
  };

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

  programs.wezterm = {
    enable = true;
    package = pkgs-unstable.wezterm;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.font = wezterm.font("JetBrainsMono Nerd Font")
      config.color_scheme = "Catppuccin Mocha"
      config.webgpu_power_preference = "HighPerformance"
      config.enable_wayland = true
      return config
    '';
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

  programs.nushell = {
    enable = true;
    configFile.text = ''
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
  };
}
