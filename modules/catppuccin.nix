{catppuccin, ...}:
{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    accent = "pink";
    flavor = "mocha";
  };
}
