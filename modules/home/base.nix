{
  config.homeManager.modules.base =
    {
      lib,
      username,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) stdenv;
      inherit (lib) mkIf mkMerge;

      extraPaths = [
        "~/.local/bin"
        "~/bin"
      ];
    in
    {
      home = {
        inherit username;
        stateVersion = "23.05";
        homeDirectory = mkMerge [
          (mkIf stdenv.isDarwin "/Users/${username}")
          (mkIf (!stdenv.isDarwin) "/home/${username}")
        ];

        sessionVariables = {
          PATH = "${lib.concatStringsSep ":" extraPaths}:$PATH";
        };
      };
      programs.home-manager.enable = true;
      xdg.enable = true;
    };
}
