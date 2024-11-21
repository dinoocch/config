{ lib, pkgs, ... }:
with lib;
let
  inherit (pkgs) stdenv;
in
{
  options.dino = {
    minimal = mkOption {
      type = types.bool;
      description = ''Disable extra programs/features'';
      default = false;
    };
    dev = {
      enable = mkEnableOption "dev";
      cpp = mkOption {
        type = types.bool;
        description = ''Install cpp build tooling'';
        default = true;
      };

      zig = mkOption {
        type = types.bool;
        description = ''Install zig tools'';
        default = true;
      };

      rust = mkOption {
        type = types.bool;
        description = ''Install rust tooling'';
        default = true;
      };

      dirEnv = mkOption {
        type = types.bool;
        description = ''Configure direnv'';
        default = true;
      };

      kubernetes = mkOption {
        type = types.bool;
        description = ''Configure kubernetes programs'';
        default = true;
      };

      nix = mkOption {
        type = types.bool;
        description = ''Configure nix linters and formatters'';
        default = true;
      };
    };

    git = {
      enable = mkEnableOption "git";

      work = mkOption {
        type = types.bool;
        description = ''Configure work specific options'';
        default = false;
      };
    };

    shells = {
      zsh = mkOption {
        type = types.bool;
        description = ''Configure zshell'';
        default = true;
      };

      fish = mkOption {
        type = types.bool;
        description = ''Configure fish'';
        default = true;
      };

      bash = mkOption {
        type = types.bool;
        description = ''Configure bash'';
        default = true;
      };

      starship = mkOption {
        type = types.bool;
        description = ''Setup starship'';
        default = true;
      };

      defaultShell = mkOption {
        type = types.enum [
          "zsh"
          "fish"
          "bash"
        ];
        default = "zsh";
      };
    };

    gui = {
      enable = mkEnableOption ''Graphical interfaces and programs'';

      desktopEnvironment = mkOption {
        type = types.enum [
          "hyprland"
          "river"
        ];
        default = "hyprland";
      };

      isWayland = mkOption {
        type = types.bool;
        readOnly = true;
        # TODO: Maybe someday use this if I want to use x11?
        default = stdenv.isLinux;
      };
    };

    prometheus = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };

      port = mkOption {
        type = types.int;
        default = 9100;
        description = ''Port to listen on'';
        readOnly = true;
      };
    };

    promtail = {
      enable = mkEnableOption ''Enable promtail and loki push'';

      lokiServer = mkOption {
        type = types.str;
        default = "10.1.1.80:3030";
      };
    };

    server = {
      enable = mkEnableOption ''Enable server role'';

      domain = mkOption {
        type = types.str;
        default = "dinoocch.dev";
      };

      matrix = {
        enable = mkEnableOption ''Enable matrix'';
      };

      grafana = {
        enable = mkEnableOption ''Enable grafana'';
      };

      loki = {
        enable = mkEnableOption ''Enable loki'';
      };
    };

    zfs = {
      enable = mkEnableOption ''Enable zfs'';
    };

    netboot = {
      enable = mkEnableOption ''Enable netboot server'';
    };
  };
}
