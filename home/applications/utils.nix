{pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    skim
    tree
    sad
    jq
    gnupg
    zstd
    unzip
    bat
    fd
    htop
    btop
    ripgrep

    # nix-build --log-format internal-json -v |& nom --json
    nix-output-monitor
  ];

  programs.eza = {
    enable = true;
    enableAliases = true;
    package = pkgs-unstable.eza;
  };

  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
