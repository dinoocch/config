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

    # Debugging utils
    nmon
    iotop
    iftop
    libnotify
    strace
    ltrace
    bpftrace
    tcpdump
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    hdparm
    dmidecode
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
