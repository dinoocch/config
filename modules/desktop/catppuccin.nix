{
  config.homeManager.modules.base =
    { inputs, ... }:
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      config = {
        catppuccin = {
          enable = true;
          accent = "pink";
          flavor = "mocha";
          gemini-cli.enable = false;
        };
      };
    };

  config.nixos.modules.base =
    { inputs, ... }:
    {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];

      config = {
        catppuccin = {
          enable = true;
          accent = "pink";
          flavor = "mocha";
        };
      };
    };
}
