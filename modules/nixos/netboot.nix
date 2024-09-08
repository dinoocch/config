{
  lib,
  config,
  nixpkgs,
  pkgs,
  extraModules ? [ ],
  ...
}:
with lib;
let
  cfg = config.dino.netboot;
  bootSystem = nixpkgs.lib.nixosSystem {
    inherit (pkgs) system;
    modules = [
      (
        {
          config,
          pkgs,
          lib,
          modulesPath,
          ...
        }:
        {
          imports = [ (modulesPath + "/installer/netboot/netboot-minimal.nix") ] ++ extraModules;
          config = {
            system.stateVersion = config.system.nixos.release;

            nix.settings = {
              auto-optimise-store = true;
              builders-use-substitutes = true;
              experimental-features = [
                "nix-command"
                "flakes"
              ];
            };

            # TODO: Reduce duplication here...
            time.timeZone = "America/Los_Angeles";
            i18n.defaultLocale = "en_US.UTF-8";
            services.getty.autologinUser = lib.mkForce "root";
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaADz4VrsCbyI5au/HeE0EK5VIS/Ffcso/3V/vK7fyc"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlyJkL8MaMzVP6LOt1Pz2V/sA3ys2L1RCU3rRyaQU6K"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaADz4VrsCbyI5au/HeE0EK5VIS/Ffcso/3V/vK7fyc"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg5HANZD6fsxFVntwZidPReOhZ/ZDq10RMQIP8ozjGT"
            ];
            services.openssh = {
              enable = true;
              settings = {
                PermitRootLogin = "yes";
                PasswordAuthentication = false;
              };
              openFirewall = true;
            };
            environment.systemPackages = with pkgs; [
              curl
              git
              vim
            ];
            environment.shells = with pkgs; [
              bash
              zsh
            ];
            users.defaultUserShell = pkgs.zsh;
            programs.zsh.enable = true;
          };
        }
      )
    ];
  };
  inherit (bootSystem.config.system) build;
in
{
  # This is definitely broken
  config = mkIf cfg.enable {
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
  };
}
