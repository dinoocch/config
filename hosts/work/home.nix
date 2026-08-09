{ config, inputs, ... }:
{
  config.flake.homeConfigurations =
    let
      workConfig = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          config.homeManager.modules.base
          config.homeManager.modules.dev
          config.homeManager.modules.git
          config.homeManager.modules.work
        ];
        extraSpecialArgs = {
          inherit inputs;
          username = "docchial";
          pkgs-unstable = import inputs.nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        };
      };
    in
    {
      "docchial@docchial-mn2" = workConfig;
      "docchial" = workConfig;
    };
}
