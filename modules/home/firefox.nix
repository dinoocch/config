{
  config,
  lib,
  inputs,
  pkgs-unstable,
  ...
}:
with lib;
let
  inherit (pkgs-unstable.stdenv) isLinux;
in
{
  imports = [ inputs.schizofox.homeManagerModule ];

  config = mkIf (config.dino.gui.enable && isLinux) {
    programs.schizofox = {
      enable = true;
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
          @import url("ShyFox/content/shy-sidebery.css");
          @import url("ShyFox/content/shy-about.css");
          @import url("ShyFox/content/shy-global-content.css");
          @import url("ShyFox/shy-variables.css");
        '';
      };

      security = {
        sanitizeOnShutdown.enable = false;
        sandbox.enable = false; # Sandbox seems to break hardware acceleration for me
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drm.enable = true;
        disableWebgl = false;
        firefoxSync = true;
      };

      extensions = {
        enableDefaultExtensions = true;
        enableExtraExtensions = true;
        darkreader.enable = true;

        simplefox.enable = false;

        extraExtensions =
          let
            extUrl = "https://addons.mozilla.org/firefox/downloads/latest";
          in
          {
            "languagetool-webextension@languagetool.org".install_url = "${extUrl}/languagetool/latest.xpi";
            "admin@2fas.com".install_url = "${extUrl}/2fas-two-factor-authentication/latest.xpi";
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".install_url = "${extUrl}/styl-us/latest.xpi";
            "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "${extUrl}/bitwarden-password-manager/latest.xpi";
            "sponsorBlocker@ajay.app".install_url = "${extUrl}/sponsorblock/latest.xpi";
            "{f209234a-76f0-4735-9920-eb62507a54cd}".install_url = "${extUrl}/unpaywall/latest.xpi";
            "gdpr@cavi.au.dk".install_url = "${extUrl}/consent-o-matic/latest.xpi";
            "{3c078156-979c-498b-8990-85f7987dd929}".install_url = "${extUrl}/sidebery/latest.xpi";
            # "CanvasBlocker@kkapsner.de".install_url = "${extUrl}/canvasblocker/latest.xpi";
            "{8446b178-c865-4f5c-8ccc-1d7887811ae3}".install_url = "${extUrl}/catppuccin-mocha-lavender-git/latest.xpi";
            "{a218c3db-51ef-4170-804b-eb053fc9a2cd}".install_url = "${extUrl}/qr-code-address-bar/latest.xpi";
            "{93f81583-1fd4-45cc-bff4-abba952167bb}".install_url = "${extUrl}/jiffy-reader/latest.xpi";
            "tridactyl.vim@cmcaine.co.uk".install_url = "${extUrl}/tridactyl-vim/latest.xpi";
          };
      };

      settings = {
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.pbmode" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";
        "extensions.quarantinedDomains.enabled" = false;
        "browser.display.use_document_fonts" = true;

        # IDK if these are needed
        "browser.cache.memory.max_entry_size" = 0;
        "gfx.canvas.accelerated.cache-items" = true;
        "gfx.canvas.accelerated.cache-size" = 4096;
        "gfx.content.skia-font-cache-size" = 80;
        "image.cache.size" = 10485760;
        "image.mem.decode_bytes_at_a_time" = 131072;
        "image.mem.shared.unmap.min_expiration_msn" = 120000;
        "media.cache_readahead_limit" = 9000;
        "media.cache_resume_threshold" = 6000;
        "media.memory_cache_max_size" = 1048576;
        "media.memory_caches_combined_limit_kb" = 2560000;
        "network.buffer.cache.count" = 128;
        "network.buffer.cache.size" = 262144;
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 30;
        "network.ssl_tokens_cache_capacity" = 32768;

        # TODO: Sandbox seems to mess with gpu stuff, so force for now
        "gfx.canvas.accelerated" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.webrender.precache-shaders" = true;
        "layers.acceleration.force-enabled" = true;
        "layers.gpu-process.enabled" = true;
        "layers.mlgpu.enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;
        "layout.css.font-visibility.private" = 1;
        "layout.css.font-visibility.standard" = 1;
        "layout.css.font-visibility.trackingprotection" = 1;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
      };
    };

    home.file = {
      ".mozilla/firefox/schizo.default/chrome/ShyFox/".source = inputs.shyfox.outPath + "/chrome/ShyFox";
      ".mozilla/firefox/schizo.default/chrome/icons/".source = inputs.shyfox.outPath + "/chrome/icons";
    };
  };
}
