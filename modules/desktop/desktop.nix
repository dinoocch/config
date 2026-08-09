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
          spotify
          zoom-us
          vscode
        ];

        fonts.fontconfig.enable = true;
        services.udiskie.enable = true;
        services.easyeffects.enable = true;
      };
    };

  config.nixos.modules.desktop =
    {
      pkgs,
      pkgs-unstable,
      inputs,
      ...
    }:
    {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];

      nixpkgs.config.allowUnfree = true;
      environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

      environment.systemPackages = with pkgs; [
        colmena
        pulseaudio
        alsa-utils
        mpd
        mpc-cli
        ncmpcpp
        yad
        aria2
        sqlite
        wget
        xterm

        # Needed even on wayland
        xsettingsd
        xorg.xrdb

        pkgs-unstable.winetricks
        pkgs-unstable.wineWowPackages.staging

        # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
        (
          let
            base = pkgs.appimageTools.defaultFhsEnvArgs;
          in
          pkgs.buildFHSEnv (
            base
            // {
              name = "fhs";
              targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
              profile = "export FHS=1";
              runScript = "bash";
              extraOutputsToInstall = [ "dev" ];
            }
          )
        )
      ];

      programs = {
        ssh.startAgent = true;
        dconf.enable = true;
        light.enable = true;

        # TODO: Figure out what is wrong with krisp...
        noisetorch.enable = true;
        nix-index-database.comma.enable = true;
      };

      security.rtkit.enable = true;

      services = {
        printing = {
          enable = true;
          drivers = [ pkgs.hplip ];
        };

        gvfs.enable = true; # Mount, trash, and other functionalities
        tumbler.enable = true; # Thumbnail support for images
        flatpak.enable = true;
        dbus.packages = [ pkgs.gcr ];
        geoclue2.enable = true;
        udev.packages = with pkgs; [
          gnome-settings-daemon
          pkgs-unstable.zsa-udev-rules
        ];

        pipewire = {
          enable = true;
          package = pkgs.pipewire;
          audio.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = false;
          wireplumber.enable = true;
        };
      };

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = false;
        config.common.default = "*";
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };

      fonts = {
        enableDefaultPackages = true;
        fontDir.enable = true;
        packages = with pkgs; [
          alegreya
          material-design-icons
          font-awesome
          noto-fonts
          source-sans
          source-serif
          pkgs-unstable.comic-code
          nerd-fonts.fira-code
          nerd-fonts.jetbrains-mono
          nerd-fonts.iosevka
        ];

        # TODO: Comic Code Ligatures
        fontconfig.defaultFonts = {
          serif = [
            "Noto Serif"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Noto Sans"
            "Noto Color Emoji"
          ];
          monospace = [
            "JetBrainsMono Nerd Font"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
}
