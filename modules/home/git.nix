{ config, lib, ... }:
with lib;
let
  cfg = config.dino.git;
in
{
  config = mkIf (config.dino.dev.enable || cfg.enable) (mkMerge [
    {
      programs = {
        gh = {
          enable = true;
        };
        lazygit.enable = true;

        git = {
          enable = true;
          userName = "dinoocch";
          userEmail = "dino.occhialini@gmail.com";
          aliases = {
            co = "checkout";
            fe = "fetch --all -p";
            fixup = "commit --amend -C HEAD";
            rev = "diff --staged -M";
            save = "commit -m 'savepoint'";
            st = "status -sb";
            lga = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
            root = "rev-parse --show-toplevel";
          };
          lfs.enable = true;
          extraConfig = {
            pull.rebase = true;
            fetch.prune = true;
            push.autosetupremote = true;
            init.defaultBranch = "main";
            merge.conflictstyle = "zdiff3";
            rebase = {
              autosquash = true;
            };
            commit.verbose = true;
            rerere = {
              enabled = true;
              autoupdate = true;
            };
            help.autocorrect = 10;
            diff.algorithm = "histogram";
            url."git@github.com:".insteadOf = "https://github.com/";
            status.submoduleSummary = true;
            gpg = {
              format = "ssh";
              signByDefault = true;
            };
            user.signingKey = mkDefault "~/.ssh/id_ed25519.pub";
          };
        };
      };
    }

    (mkIf (!config.dino.minimal) { programs.git.delta.enable = true; })

    (mkIf cfg.work {
      programs.git = {
        extraConfig = {
          core = {
            sshCommand = "ssh -i ~/.ssh/github_personal";
          };
          user.signingKey = lib.mkForce "~/.ssh/github_personal.pub";
        };
        includes = [
          {
            path = "~/.config/git/linkedin.inc";
            condition = "gitdir:~/li/";
          }
        ];
      };

      xdg.configFile."git/linkedin.inc".text = ''
        [user]
        name = docchial
        email = "docchial@linkedin.com"
        signingKey = "~/.ssh/docchial_at_linkedin.com_ssh_key.pub"

        [core]
        sshCommand = "ssh -i ~/.ssh/docchial_at_linkedin.com_ssh_key"
      '';
    })
  ]);
}
