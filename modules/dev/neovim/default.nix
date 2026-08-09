{
  config.homeManager.modules.base =
    {
      pkgs-unstable,
      ...
    }:
    {
      config = {

        home = {
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
            withRuby = false;
          };
        };
      };
    };
}
