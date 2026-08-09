{
  config,
  lib,
  modulesPath,
  ...
}:
let
  hasFacterReport = builtins.pathExists ./rome.facter.json;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Once ./rome.facter.json exists (generated via `sudo nix run nixpkgs#nixos-facter -- -o rome.facter.json`
  # on the physical host), hardware detection (kernel modules, CPU microcode, etc.) is derived from
  # the report instead of the hand-maintained fallback below.
  hardware.facter.reportPath = lib.mkIf hasFacterReport ./rome.facter.json;

  boot = lib.mkIf (!hasFacterReport) {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "rpool/nixos/root";
      fsType = "zfs";
    };

    "/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B7AE-FE12";
      fsType = "vfat";
    };

    "/var/lib" = {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
    };

    "/var/log" = {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
    };

    "/nix" = {
      device = "rpool/nixos/nix";
      fsType = "zfs";
    };
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkIf (!hasFacterReport) (
    lib.mkDefault config.hardware.enableRedistributableFirmware
  );
}
