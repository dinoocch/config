{
  config.homeManager.modules.herdr =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ herdr ];
    };
}
