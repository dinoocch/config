{config, pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    tree-sitter
    lua-language-server
    stylua
    shfmt
    pyright
    rust-analyzer
    rustfmt
    taplo
    # rnix-lsp
    nixpkgs-fmt
  ];

  programs = {
    neovim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;
      defaultEditor = true;
      viAlias = false;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
    };
  };

  home.file.".config/nvim" = {
    source = ./config;
  };
}
