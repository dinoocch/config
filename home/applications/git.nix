{lib, ...}: {
  programs.gh = {
    enable = true;
  };
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
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
      user.signingKey = lib.mkDefault "~/.ssh/id_ed25519.pub";
    };
  };
}
