{pkgs, pkgs-unstable, ...}: {
  home.packages = with pkgs; [
    tree-sitter
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

  xdg.configFile."nvim".source = ./config;
}
