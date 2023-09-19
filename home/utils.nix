{pkgs, ...}: {
  home.packages = with pkgs; [
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

  services.udiskie.enable = true;
}
