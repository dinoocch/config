{ ... }:
{
  imports = [ ../../modules/home ];
  config.dino = {
    dev.enable = true;
    git.enable = true;
  };
}
