{ lib, ... }:
with lib;
{
  options.dino = {
    minimal = mkOption {
      type = types.bool;
      description = "Disable extra programs/features";
      default = false;
    };
    dev = {
      cpp = mkOption {
        type = types.bool;
        description = "Install cpp build tooling";
        default = true;
      };

      zig = mkOption {
        type = types.bool;
        description = "Install zig tools";
        default = true;
      };

      rust = mkOption {
        type = types.bool;
        description = "Install rust tooling";
        default = true;
      };

      dirEnv = mkOption {
        type = types.bool;
        description = "Configure direnv";
        default = true;
      };

      kubernetes = mkOption {
        type = types.bool;
        description = "Configure kubernetes programs";
        default = true;
      };

      nix = mkOption {
        type = types.bool;
        description = "Configure nix linters and formatters";
        default = true;
      };
    };

    git = {
      work = mkOption {
        type = types.bool;
        description = "Configure work specific options";
        default = false;
      };
    };

    shells = {
      zsh = mkOption {
        type = types.bool;
        description = "Configure zshell";
        default = true;
      };

      fish = mkOption {
        type = types.bool;
        description = "Configure fish";
        default = true;
      };

      bash = mkOption {
        type = types.bool;
        description = "Configure bash";
        default = true;
      };

      starship = mkOption {
        type = types.bool;
        description = "Setup starship";
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
      desktopEnvironment = mkOption {
        type = types.enum [
          "hyprland"
          "river"
        ];
        default = "hyprland";
      };
    };

    nvidia = {
      enable = mkEnableOption "Nvidia graphics drivers";
    };

    prometheus = {
      port = mkOption {
        type = types.int;
        default = 9100;
        description = "Port to listen on";
        readOnly = true;
      };
    };

    promtail = {
      lokiServer = mkOption {
        type = types.str;
        default = "10.1.1.80:3030";
      };
    };

    server = {
      domain = mkOption {
        type = types.str;
        default = "dinoocch.dev";
      };
    };
  };
}
