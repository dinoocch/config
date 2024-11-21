{
  config,
  lib,
  pkgs,
  # inputs,
  ...
}:
with lib;
# let
# spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
# in
{
  # imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config = mkIf config.dino.gui.enable {
    # programs.spicetify = {
    #   enable = true;
    #   theme = spicePkgs.themes.catppuccin;
    #   colorScheme = "mocha";
    # };
    home.packages = with pkgs; [ spotify ];
  };
}
