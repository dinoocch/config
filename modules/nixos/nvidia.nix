{ lib, config, ... }:
with lib;

let
  cfg = config.dino.gui;
in

{
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = true;
      nvidiaSettings = false;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "565.77";
      #   sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
      #   sha256_aarch64 = lib.fakeHash;
      #   openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
      #   settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
      #   persistencedSha256 = lib.fakeHash;
      # };
    };

    hardware.graphics.enable = true;
    boot = {
      kernelParams = [
        "nvidia_drm.fbdev=1"
        "nvidia-drm.modeset=1"
      ];
      kernelModules = [
        "nvidia_uvm" # TODO:nixpkgs#334340
      ];
      extraModprobeConfig =
        "options nvidia "
        + lib.concatStringsSep " " [
          "NVreg_UsePageAttributeTable=1"
          "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
        ];
    };
  };
}
