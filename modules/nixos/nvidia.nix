{
  config.nixos.modules.nvidia =
    { lib, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        open = true;
        nvidiaSettings = false;
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
