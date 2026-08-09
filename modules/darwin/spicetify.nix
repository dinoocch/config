{
  config.homeManager.modules.spicetify =
    {
      lib,
      pkgs-unstable,
      # inputs,
      ...
    }:
    let
      inherit (pkgs-unstable.stdenv) isLinux;
    in
    # let
    # spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    # in
    {
      # imports = [ inputs.spicetify-nix.homeManagerModules.default ];

      config = lib.mkIf isLinux {
        # programs.spicetify = {
        #   enable = true;
        #   theme = spicePkgs.themes.catppuccin;
        #   colorScheme = "mocha";
        # };
        home.packages = with pkgs-unstable; [ spotify ];
      };
    };
}
