{...}: {
  programs.gh = {
    enable = true;
  };

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
    };
  };
}
