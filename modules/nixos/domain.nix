{
  config.nixos.modules.domain =
    { lib, ... }:
    {
      # Shared by modules/nixos/conduit.nix and modules/nixos/cfdyndns.nix.
      options.dino.server.domain = lib.mkOption {
        type = lib.types.str;
        default = "dinoocch.dev";
      };
    };
}
