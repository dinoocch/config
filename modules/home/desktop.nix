{
  config.homeManager.modules.desktop =
    {
      lib,
      pkgs,
      pkgs-unstable,
      ...
    }:
    let
      inherit (pkgs) stdenv;
    in
    {
      config = lib.mkIf stdenv.isLinux {
        home.packages = with pkgs-unstable; [
          lutris
          steam
          steam-run
          steamtinkerlaunch
          discord-canary
          protontricks
          element-desktop
          audacity
          gimp
          krita
          vlc
          zoom-us
          vscode
        ];

        fonts.fontconfig.enable = true;
        services.udiskie.enable = true;
        services.easyeffects.enable = true;
      };
    };
}
