{
  config.homeManager.modules.dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.dino.dev;
    in
    {
      config = mkMerge [
        (mkIf cfg.zig {
          home.packages = with pkgs; [
            zig
            zls
          ];
        })

        (mkIf cfg.cpp {
          home.packages = with pkgs; [
            gnumake
            gcc
          ];
        })

        (mkIf cfg.rust {
          home.packages = with pkgs; [
            iconv
            rustc
            cargo
            cargo-generate
            cargo-flamegraph
            cargo-nextest
            cargo-watch
            rust-analyzer
            rustPlatform.rustcSrc
          ];

          home.sessionVariables = {
            RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
            RUST_BACKTRACE = 1;
          };
        })

        (mkIf cfg.dirEnv { programs.direnv.enable = true; })

        (mkIf cfg.kubernetes { programs.k9s.enable = true; })

        {
          # LSPs/formatters for neovim (modules/home/neovim) that only make
          # sense when this dev module is imported.
          home.packages = with pkgs; [
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
            fzf
          ];
        }
      ];
    };
}
