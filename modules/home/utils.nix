{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    skim
    tree
    sad
    jq
    gnupg
    zstd
    unzip
    fd
    htop
    btop
    ripgrep

    # nix-build --log-format internal-json -v |& nom --json
    nix-output-monitor
  ];

  programs = {
    bat.enable = true;

    eza = {
      enable = true;
      # enableZshIntegration = true;
      package = pkgs-unstable.eza;
    };

    yazi = {
      enable = true;
      package = pkgs-unstable.yazi;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
