{
  config,
  inputs,
  lib,
  ...
}:
{
  options.colmena.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          nixosModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            description = "NixOS modules to compose for this colmena-deployed host.";
          };
          homeModule = lib.mkOption {
            type = lib.types.nullOr lib.types.deferredModule;
            default = null;
            description = "home-manager module for this host's primary user, if any.";
          };
          targetUser = lib.mkOption {
            type = lib.types.str;
            default = config.meta.username;
          };
        };
      }
    );
    default = { };
    description = "Hosts to deploy remotely via colmena.";
  };

  config.flake.colmena =
    lib.foldl' lib.recursiveUpdate
      {
        meta = {
          specialArgs = config.meta.linuxSpecialArgs;
          nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        };
      }
      (
        lib.mapAttrsToList (name: hostCfg: {
          ${name} = import ./_lib/colmenaSystem.nix {
            inherit (inputs) nixpkgs home-manager;
            specialArgs = config.meta.linuxSpecialArgs;
            nixos-modules = hostCfg.nixosModules;
            home-module = hostCfg.homeModule;
            inherit (hostCfg) targetUser;
          };
        }) config.colmena.hosts
      );
}
