{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
with lib;
{
  config = {

    home = {
      packages = mkIf config.dino.dev.enable (
        with pkgs;
        [
          tree-sitter
          lua-language-server
          stylua
          shfmt
          pyright
          rust-analyzer
          rustfmt
          taplo
          nixpkgs-fmt
          nil
        ]
      );
      file.".config/nvim" = {
        source = ./config;
      };
    };

    programs = {
      neovim = {
        enable = true;
        package = pkgs-unstable.neovim-unwrapped;
        defaultEditor = true;
        viAlias = false;
        vimAlias = true;
        withPython3 = false;
        withNodeJs = false;
      };
    };
  };
}
