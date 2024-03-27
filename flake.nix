{
  description = "dinoocch/config";


  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /* flake-parts.url = "github:hercules-ci/flake-parts"; */

    # darwin = {
    #   url = "github:lnl7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ { self, home, nixpkgs, fenix, ... }:
  let
    /* inputs.flake-parts.lib.mkFlake { inherit inputs; } { */
    nixpkgs_config = {
      allowUnfree = true;
    };
    
    overlays = [
      inputs.neovim-nightly-overlay.overlay
      fenix.overlays.default
      (self: super:
        {
          zsh-defer = super.callPackage ./pkgs/zsh-defer.nix { };
        }
      )
    ];

  in {
    homeConfigurations = {
      docchial = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            nixpkgs.overlays = overlays;
            home = {
              username = "docchial";
              homeDirectory = "/home/docchial";
              stateVersion = "22.11";
            };
          }
          ./home.nix
        ];
      };

      dino = home.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            nixpkgs.overlays = overlays;
            home = {
              username = "dino";
              homeDirectory = "/home/dino";
              stateVersion = "22.11";
            };
          }
          ./home.nix
        ];
      };
    };
  };
}
