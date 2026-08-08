{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
in
{
  config = mkIf (stdenv.isDarwin && config.dino.git.work) {
    home.file.".finicky.js".text = ''
      // @ts-check

      /**
       * @typedef {import('/Applications/Finicky.app/Contents/Resources/finicky.d.ts').FinickyConfig} FinickyConfig
       */

      const workBrowser = {
        name: "Google Chrome",
        profile: "Work",
      };

      const personalBrowser = {
        name: "Google Chrome",
        profile: "Personal",
      };

      const googleWorkspaceHosts = new Set([
        "docs.google.com",
        "drive.google.com",
        "forms.google.com",
        "script.google.com",
        "sheets.google.com",
        "sites.google.com",
        "slides.google.com",
      ]);

      const isLinkedInHost = (hostname) =>
        hostname === "linkedin.com" ||
        hostname.endsWith(".linkedin.com") ||
        hostname === "linkedin.okta.com";

      const isEnterpriseGitHubRepository = (url) =>
        url.hostname === "github.com" &&
        /^\/linkedin-[^/]+(?:\/|$)/i.test(url.pathname);

      const isLinkedInEnterpriseSso = (url) =>
        url.hostname === "github.com" &&
        /^\/enterprises\/linkedin-enterprise\/sso(?:\/|$)/i.test(url.pathname);

      const isGitHubPagesHost = (hostname) =>
        hostname === "github.io" || hostname.endsWith(".github.io");

      /** @type {FinickyConfig} */
      export default {
        defaultBrowser: personalBrowser,
        options: {
          logRequests: false,
        },
        handlers: [
          {
            match: isEnterpriseGitHubRepository,
            browser: workBrowser,
          },
          {
            match: isLinkedInEnterpriseSso,
            browser: workBrowser,
          },
          {
            match: (url) => isGitHubPagesHost(url.hostname),
            browser: workBrowser,
          },
          {
            match: (url) => isLinkedInHost(url.hostname),
            browser: workBrowser,
          },
          {
            match: (url) => googleWorkspaceHosts.has(url.hostname),
            browser: workBrowser,
          },
          {
            match: (url) =>
              url.hostname === "github.com" ||
              url.hostname.endsWith(".github.com"),
            browser: personalBrowser,
          },
        ],
      };
    '';
  };
}
