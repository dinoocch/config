{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
with lib;
let
  cfg = config.dino.shells;
in
{
  config = mkMerge [
    (mkIf cfg.fish {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          fish_vi_key_bindings
        '';
      };
      programs.starship.enableFishIntegration = true;
    })

    (mkIf cfg.zsh {
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
      programs.starship.enableZshIntegration = true;
    })

    (mkIf cfg.bash {
      programs.bash.enable = true;
      programs.starship.enableBashIntegration = true;
    })

    (mkIf cfg.starship {
      programs.starship = {
        enable = true;
        settings = {
          character = {
            success_symbol = "[[♥](green) ❯](sky)";
            error_symbol = "[❯](red)";
            vicmd_symbol = "[❮](green)";
          };
        };
      };
    })
  ];
}
