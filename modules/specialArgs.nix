{
  config,
  inputs,
  lib,
  ...
}:
let
  x64_system = "x86_64-linux";
in
{
  # `meta.*` describes this flake itself (identity/specialArgs shared across
  # every host). This is a distinct namespace from the nested `dino.*` options,
  # which are declared alongside the individual NixOS/home-manager modules
  # that consume them and are per-host feature toggles/values evaluated
  # inside separate module-system evaluations. Naming them differently avoids
  # confusing the two.
  options.meta = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "dino";
    };
    userfullname = lib.mkOption {
      type = lib.types.str;
      default = "Dino Occhialini";
    };
    useremail = lib.mkOption {
      type = lib.types.str;
      default = "dino.occhialini@gmail.com";
    };

    linuxSpecialArgs = lib.mkOption {
      type = lib.types.raw;
      description = ''
        specialArgs shared by every x86_64-linux nixosSystem/colmena host
        in this flake.
      '';
    };
  };

  config.meta.linuxSpecialArgs = {
    inherit inputs;
    inherit (config.meta) username userfullname useremail;
    pkgs = import inputs.nixpkgs {
      system = x64_system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = x64_system;
      config.allowUnfree = true;
      overlays = [ inputs.custom-fonts.overlay ];
    };
  };
}
