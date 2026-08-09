{
  config,
  lib,
  modulesPath,
  ...
}:
let
  hasFacterReport = builtins.pathExists ./venice.facter.json;
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Once ./venice.facter.json exists (generated via `sudo nix run nixpkgs#nixos-facter -- -o venice.facter.json`
  # on the physical host), hardware detection (kernel modules, CPU microcode, etc.) is derived from
  # the report instead of the hand-maintained fallback below.
  hardware.facter.reportPath = lib.mkIf hasFacterReport ./venice.facter.json;

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
    device = "/dev/disk/by-uuid/61c3f19a-26ec-4e2b-b38d-63409537fa6b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CA72-E2F3";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkIf (!hasFacterReport) (
    lib.mkDefault config.hardware.enableRedistributableFirmware
  );
}
