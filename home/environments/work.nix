{lib, username, ...}: {
  imports = [
    ../applications/zsh.nix
    ../applications/git.nix
    ../applications/dev.nix
    ../applications/terminal.nix
    ../applications/mac.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "23.05";
  };

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
}
