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

  programs.wezterm = {
    enable = true;
    package = pkgs-unstable.wezterm;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.font = wezterm.font("Comic Code Ligatures")
      config.color_scheme = "Catppuccin Mocha"
      config.webgpu_power_preference = "HighPerformance"
      return config
    '';
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
