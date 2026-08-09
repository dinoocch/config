{
  config.homeManager.modules.base =
    {
      config,
      pkgs,
      pkgs-unstable,
      ...
    }:
    let
      wt = "${pkgs.worktrunk}/bin/wt";
    in
    {
      programs = {
        fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting
            fish_vi_key_bindings
            ${wt} config shell init fish | source
          '';
        };

        zsh = {
          enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          autocd = true;
          cdpath = [ "~" ];
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
          initContent = ''
            if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
              source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
            fi
            source "${pkgs-unstable.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh"
            zsh-defer source "${pkgs.skim}/share/skim/key-bindings.zsh"
            zsh-defer source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
            zsh-defer source "${pkgs.grc}/etc/grc.zsh"
            path=('/Users/docchial/.cargo/bin' '/Users/docchial/.local/bin' '/Users/docchial/bin' $path)
            export PATH
            export VOLTA_HOME="$HOME/.volta"
            export PATH="$VOLTA_HOME/bin:$PATH"
            eval "$(${wt} config shell init zsh)"
          '';
        };

        bash = {
          enable = true;
          initExtra = ''
            eval "$(${wt} config shell init bash)"
          '';
        };

        starship = {
          enable = true;
          enableFishIntegration = true;
          enableZshIntegration = true;
          enableBashIntegration = true;
          settings = {
            character = {
              success_symbol = "[[♥](green) ❯](sky)";
              error_symbol = "[❯](red)";
              vicmd_symbol = "[❮](green)";
            };
          };
        };
      };
    };
}
