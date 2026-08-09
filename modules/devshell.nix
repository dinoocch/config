{ inputs, ... }:
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;

      pre-commit.settings.hooks = {
        nixfmt-rfc-style.enable = true;
        statix.enable = true;
      };

      devShells.default = config.pre-commit.devShell;
    };
}
