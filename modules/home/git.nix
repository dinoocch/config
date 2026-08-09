{
  config.homeManager.modules.git =
    { config, lib, ... }:
    with lib;
    let
      cfg = config.dino.git;
    in
    {
      config = mkMerge [
        {
          programs = {
            gh = {
              enable = true;
            };
            lazygit.enable = true;

            git = {
              enable = true;
              lfs.enable = true;
              settings = {
                user = {
                  name = "dinoocch";
                  email = "dino.occhialini@gmail.com";
                };
                alias = {
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
                pull.rebase = true;
                fetch.prune = true;
                push.autosetupremote = true;
                init.defaultBranch = "master";
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

        (mkIf (!config.dino.minimal) {
          programs.delta = {
            enable = true;
            enableGitIntegration = true;
          };
        })

        (mkIf cfg.work {
          programs.git = {
            settings = {
              user = {
                name = lib.mkForce "docchial";
                email = lib.mkForce "docchial@linkedin.com";
                signingKey = lib.mkForce "~/.ssh/docchial_at_linkedin.com_ssh_key.pub";
              };
              core.sshCommand = "ssh -i ~/.ssh/docchial_at_linkedin.com_ssh_key -o IdentitiesOnly=yes";
              url."ssh://git@github.com/".insteadOf = "git@github-personal:";
            };
            includes = [
              {
                path = "~/.config/git/personal.inc";
                condition = "hasconfig:remote.*.url:git@github.com:*/**";
              }
              {
                path = "~/.config/git/personal.inc";
                condition = "hasconfig:remote.*.url:https://github.com/**";
              }
              {
                path = "~/.config/git/personal.inc";
                condition = "hasconfig:remote.*.url:ssh://git@github.com/**";
              }
              {
                path = "~/.config/git/personal.inc";
                condition = "hasconfig:remote.*.url:git@github-personal:*/**";
              }
            ];
          };

          xdg.configFile."git/personal.inc".text = ''
            [user]
            name = dinoocch
            email = "dino.occhialini@gmail.com"
            signingKey = "~/.ssh/github_personal.pub"

            [core]
            sshCommand = "ssh -i ~/.ssh/github_personal -o IdentitiesOnly=yes"
          '';
        })
      ];
    };
}
