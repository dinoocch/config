{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  config = {
    catppuccin = {
      enable = true;
      accent = "pink";
      flavor = "mocha";
    };
  };
}
