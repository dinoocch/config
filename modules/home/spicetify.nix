{
  config,
  lib,
  pkgs-unstable,
  # inputs,
  ...
}:
with lib;
let
  inherit (pkgs-unstable.stdenv) isLinux;
in
# let
# spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
# in
{
  # imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config = mkIf (config.dino.gui.enable && isLinux) {
    # programs.spicetify = {
    #   enable = true;
    #   theme = spicePkgs.themes.catppuccin;
    #   colorScheme = "mocha";
    # };
    home.packages = with pkgs-unstable; [ spotify ];
  };
}
