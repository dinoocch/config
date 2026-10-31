{
  config.nixos.modules.noctalia =
    { lib, ... }:
    {
      security.pam.services.noctalia = { };
      security.polkit.enable = true;
      services.upower.enable = lib.mkDefault true;
    };

  config.homeManager.modules.noctalia =
    {
      config,
      lib,
      pkgs,
      pkgs-unstable,
      ...
    }:
    let
      inherit (pkgs-unstable) noctalia;
      settings = (pkgs.formats.toml { }).generate "noctalia-config.toml" {
        theme = {
          mode = "dark";
          source = "custom";
          custom_palette = "Catppuccin-Mocha-Pink";
        };
        shell = {
          polkit_agent = true;
          launch_apps_as_systemd_services = true;
        };
      };
    in
    {
      config = lib.mkIf pkgs.stdenv.isLinux {
        home.packages = [ noctalia ];
        services.mako.enable = false;

        xdg.configFile = {
          "noctalia/config.toml".source = pkgs.runCommand "noctalia-config.toml" { } ''
            ${lib.getExe noctalia} config validate ${settings}
            cp ${settings} $out
          '';
          "noctalia/palettes/Catppuccin-Mocha-Pink.json".text = builtins.toJSON {
            dark = {
              mPrimary = "#f5c2e7";
              mOnPrimary = "#11111b";
              mSecondary = "#cba6f7";
              mOnSecondary = "#11111b";
              mTertiary = "#94e2d5";
              mOnTertiary = "#11111b";
              mError = "#f38ba8";
              mOnError = "#11111b";
              mSurface = "#1e1e2e";
              mOnSurface = "#cdd6f4";
              mSurfaceVariant = "#313244";
              mOnSurfaceVariant = "#a6adc8";
              mOutline = "#585b70";
              mShadow = "#11111b";
              mHover = "#45475a";
              mOnHover = "#cdd6f4";
            };
          };
        };

        systemd.user.services.noctalia = {
          Unit = {
            Description = "Noctalia desktop shell";
            PartOf = [ config.wayland.systemd.target ];
            After = [ config.wayland.systemd.target ];
            X-Restart-Triggers = [
              "${config.xdg.configFile."noctalia/config.toml".source}"
              "${config.xdg.configFile."noctalia/palettes/Catppuccin-Mocha-Pink.json".source}"
            ];
          };
          Service = {
            ExecStart = lib.getExe noctalia;
            Restart = "on-failure";
          };
          Install.WantedBy = [ config.wayland.systemd.target ];
        };
      };
    };
}
