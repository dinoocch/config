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
            type = lib.types.nullOr (lib.types.listOf lib.types.deferredModule);
            default = null;
            description = ''
              NixOS modules to compose for this colmena-deployed host.
              Defaults to the matching `nixos.hosts.<name>.nixosModules`, if any.
            '';
          };
          homeModule = lib.mkOption {
            type = lib.types.nullOr lib.types.deferredModule;
            default = null;
            description = ''
              home-manager module for this host's primary user, if any.
              Defaults to the matching `nixos.hosts.<name>.homeModule`, if set.
            '';
          };
          targetUser = lib.mkOption {
            type = lib.types.str;
            default = "root";
            description = ''
              SSH user colmena logs in and activates as. Defaults to `root`
              (these hosts allow root SSH login, so no `sudo` escalation is
              needed during activation).
            '';
          };
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
            description = ''
              nixpkgs system to build this host for. Only hosts whose `system`
              differs from the flake-wide default are pinned via colmena's
              `meta.nodeNixpkgs`.
            '';
          };
        };
      }
    );
    default = { };
    description = "Hosts to deploy remotely via colmena.";
  };

  config.flake.colmena = {
    meta = {
      specialArgs = config.meta.linuxSpecialArgs;
      nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      # Per-node Nixpkgs pin for hosts targeting a different `system` than the
      # default above. See https://colmena.cli.rs meta.nodeNixpkgs.
      nodeNixpkgs = lib.filterAttrs (_name: v: v != null) (
        lib.mapAttrs (
          _name: hostCfg: if hostCfg.system != "x86_64-linux" then import inputs.nixpkgs { inherit (hostCfg) system; } else null
        ) config.colmena.hosts
      );
    };
  }
  // (
    lib.mapAttrs (
      name: hostCfg:
      import ./_lib/colmenaSystem.nix {
        inherit (inputs) nixpkgs home-manager;
        specialArgs = config.meta.linuxSpecialArgs;
        nixos-modules =
          if hostCfg.nixosModules != null then
            hostCfg.nixosModules
          else if config.nixos.hosts ? ${name} then
            config.nixos.hosts.${name}.nixosModules
          else
            throw "colmena.hosts.${name}.nixosModules must be set, or a matching nixos.hosts.${name} must exist to inherit from.";
        home-module =
          if hostCfg.homeModule != null then
            hostCfg.homeModule
          else if config.nixos.hosts ? ${name} then
            config.nixos.hosts.${name}.homeModule
          else
            null;
        inherit (hostCfg) targetUser;
      }
    ) config.colmena.hosts
  );
}
