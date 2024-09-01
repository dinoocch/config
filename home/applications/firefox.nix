{username, schizofox, shyfox, pkgs-unstable, ...}:
let
  extUrl = "https://addons.mozilla.org/firefox/downloads/latest";
in
  {
  imports = [ schizofox.homeManagerModule ];
  programs.schizofox = {
    enable = true;
    package = pkgs-unstable.firefox-beta-unwrapped;

    theme = {
      font = "Alegreya";
      defaultUserChrome.enable = false;
      defaultUserContent.enable = false;

      extraUserChrome = ''
        @import url("ShyFox/shy-variables.css");
        @import url("ShyFox/shy-global.css");
        @import url("ShyFox/shy-sidebar.css");
        @import url("ShyFox/shy-toolbar.css");
        @import url("ShyFox/shy-navbar.css");
        @import url("ShyFox/shy-findbar.css");
        @import url("ShyFox/shy-controls.css");
        @import url("ShyFox/shy-compact.css");
        @import url("ShyFox/shy-icons.css");
        @import url("ShyFox/shy-floating-search.css");
      '';

      extraUserContent = ''
        @import url("ShyFox/content/shy-new-tab.css");
        @import url("ShyFox/content/shy-about.css");
        @import url("ShyFox/content/shy-global-content.css");
        @import url("ShyFox/shy-variables.css");
      '';
    };


    security = {
      sanitizeOnShutdown = false;
      sandbox = true;
      userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      extraSandboxBinds = [
        "/home/${username}/.config/tridactyl"
        "/etc/profiles/per-user/${username}/share/icons"
        "/nix/store"
      ];
    };

    misc = {
      drm.enable = true;
      disableWebgl = false;
      firefoxSync = true;
      # TODO
      # startPageURL = "file://${builtins.readFile ./startpage.html}";
    };

    extensions = {
      enableDefaultExtensions = true;
      enableExtraExtensions = true;
      darkreader.enable = true;

      simplefox.enable = false;

      extraExtensions = {
        "languagetool-webextension@languagetool.org".install_url = "${extUrl}/languagetool/latest.xpi";
        "admin@2fas.com".install_url = "${extUrl}/2fas-two-factor-authentication/latest.xpi";
        "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".install_url = "${extUrl}/styl-us/latest.xpi";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "${extUrl}/bitwarden-password-manager/latest.xpi";
        "sponsorBlocker@ajay.app".install_url = "${extUrl}/sponsorblock/latest.xpi";
        "{f209234a-76f0-4735-9920-eb62507a54cd}".install_url = "${extUrl}/unpaywall/latest.xpi";
        "gdpr@cavi.au.dk".install_url = "${extUrl}/consent-o-matic/latest.xpi";
        "{3c078156-979c-498b-8990-85f7987dd929}".install_url = "${extUrl}/sidebery/latest.xpi";
        "CanvasBlocker@kkapsner.de".install_url = "${extUrl}/canvasblocker/latest.xpi";
        "{8446b178-c865-4f5c-8ccc-1d7887811ae3}".install_url = "${extUrl}/catppuccin-mocha-lavender-git/latest.xpi";
        "{a218c3db-51ef-4170-804b-eb053fc9a2cd}".install_url = "${extUrl}/qr-code-address-bar/latest.xpi";
        "{93f81583-1fd4-45cc-bff4-abba952167bb}".install_url = "${extUrl}/jiffy-reader/latest.xpi";
        "tridactyl.vim@cmcaine.co.uk".install_url = "${extUrl}/tridactyl-vim/latest.xpi";
      };
    };
  };

  home.file = {
    ".mozilla/firefox/schizo.default/chrome/ShyFox/".source = shyfox.outPath + "/chrome/ShyFox";
    ".mozilla/firefox/schizo.default/chrome/icons/".source = shyfox.outPath + "/chrome/icons";
  };
}
