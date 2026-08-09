{ lib, ... }:
{
  options = {
    nixos.modules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = ''
        Named NixOS modules. Modules assigned under the same name are
        merged together, and can be composed into a `nixosConfiguration`
        by referencing `config.nixos.modules.<name>`.
      '';
    };

    homeManager.modules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = ''
        Named home-manager modules. Modules assigned under the same name
        are merged together, and can be composed into a home-manager
        configuration by referencing `config.homeManager.modules.<name>`.
      '';
    };
  };
}
