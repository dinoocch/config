{
  config.homeManager.modules.herdr =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [ herdr ];
    };
}
