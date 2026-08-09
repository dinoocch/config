{
  config,
  inputs,
  lib,
  ...
}:
{
  options.nixos.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
            description = "The nixpkgs system string to build this host for.";
          };
          nixosModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            description = "NixOS modules to compose for this host's nixosConfiguration.";
          };
          homeModule = lib.mkOption {
            type = lib.types.deferredModule;
            description = "home-manager module for this host's primary user.";
          };
        };
      }
    );
    default = { };
    description = "Hosts to build via `flake.nixosConfigurations`.";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    name: hostCfg:
    import ./_lib/nixosSystem.nix {
      inherit (inputs) nixpkgs home-manager;
      inherit (hostCfg) system;
      specialArgs = config.meta.linuxSpecialArgs;
      nixos-modules = hostCfg.nixosModules;
      home-module = hostCfg.homeModule;
    }
  ) config.nixos.hosts;
}
