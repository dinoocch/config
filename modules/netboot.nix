{ pkgs, nixosSystem, extraModules ? [ ], ...}:
let
  bootSystem = nixosSystem {
    inherit (pkgs) system;
    modules = [
      ../modules/base.nix
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [
          (modulesPath + "/installer/netboot/netboot-minimal.nix")
        ] ++ extraModules;
        config = {
          services.getty.autologinUser = lib.mkForce "root";
          users.users.root.openssh.authorizedKeys.keys = [  ];
          system.stateVersion = config.system.nixos.release;
          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaADz4VrsCbyI5au/HeE0EK5VIS/Ffcso/3V/vK7fyc"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlyJkL8MaMzVP6LOt1Pz2V/sA3ys2L1RCU3rRyaQU6K"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaADz4VrsCbyI5au/HeE0EK5VIS/Ffcso/3V/vK7fyc"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg5HANZD6fsxFVntwZidPReOhZ/ZDq10RMQIP8ozjGT"
          ];
        };
      })
    ];
  };
  build = bootSystem.config.system.build;
in {
  services.pixiecore = {
    enable = true;
    debug = true;
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    dhcpNoBind = true;
    port = 64172;
    statusPort = 64172;
    # TODO: Figure out how to define network topology lol
    listen = "10.1.1.1";
  };
}
