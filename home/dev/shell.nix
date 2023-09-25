{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    fd
    htop
    ripgrep
  ];

  # programs.eza = {
  #  enable = true;
  #  enableAliases = true;
  #  package = pkgs-unstable.eza;
  # };

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
  };
}
