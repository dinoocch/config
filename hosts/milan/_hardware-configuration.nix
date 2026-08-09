{
  config,
  lib,
  modulesPath,
  ...
}:
let
  hasFacterReport = builtins.pathExists ./milan.facter.json;
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Once ./milan.facter.json exists (generated via `sudo nix run nixpkgs#nixos-facter -- -o milan.facter.json`
  # on the physical host), hardware detection (kernel modules, CPU microcode, etc.) is derived from
  # the report instead of the hand-maintained fallback below.
  hardware.facter.reportPath = lib.mkIf hasFacterReport ./milan.facter.json;

  boot = lib.mkIf (!hasFacterReport) {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "sdhci_pci"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/34cd6a57-4ba8-461d-9b88-fbf0a4d8c1e0";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/339B-7288";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkIf (!hasFacterReport) (
    lib.mkDefault config.hardware.enableRedistributableFirmware
  );
}
