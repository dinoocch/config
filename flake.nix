{
  description = "dinoocch/config";


  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ { self, home, nixpkgs, ... }:
  let
    nixpkgs_config = {
      allowUnfree = true;
    };

    overlays = [
      inputs.neovim-nightly-overlay.overlay
      (self: super:
        {
          zsh-defer = super.callPackage ./pkgs/zsh-defer.nix { };
        }
      )
    ];

  in {
    homeConfigurations = {
      docchial = home.lib.homeManagerConfiguration {
        system = "x86_64-darwin";
        username = "docchial";
        homeDirectory = "/Users/docchial";
        configuration = { pkgs, imports, ... }:
          {
            imports = [ ./home.nix ];
            nixpkgs.overlays = overlays;
          };
      };

      dino = home.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        username = "dino";
        homeDirectory = "/home/dino";
        # configuration.imports = [ ./home.nix ];
        configuration = { pkgs, imports, ... }:
          {
            imports = [ ./home.nix ];
            nixpkgs.overlays = overlays;
          };
      };
    };
  };
}
