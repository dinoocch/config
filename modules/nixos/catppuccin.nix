{ inputs, ... }:
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  config = {
    catppuccin = {
      enable = true;
      accent = "pink";
      flavor = "mocha";
    };
  };
}
