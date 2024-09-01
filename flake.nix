{
  description = "Various NixOS and home-manager configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Secrets
    # agenix.url = "github:yaxitech/ragenix";
    # secrets = {
    #   url = "git+ssh://git@github.com/dinoocch/secrets";
    # };
    custom-fonts = {
      url = "git+ssh://git@github.com/dinoocch/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager for non-system configs
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    conduit = {
        url = "gitlab:famedly/conduit";
        # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=838ed87d6ffae0dbdc8a3ecaac2c8be006f6d053";
    };

    schizofox = {
      url = "github:schizofox/schizofox/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shyfox = {
      url = "github:naezr/shyfox";
      flake = false;
    };

   wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org"
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    conduit,
    custom-fonts,
    nixpkgs-unstable,
    nix-darwin,
    home-manager,
    ...
  }: let
    username = "dino";
    userfullname = "Dino Occhialini";
    useremail = "dino.occhialini@gmail.com";

    x64_system = "x86_64-linux";
    x64_darwin = "x86_64-darwin";
    aarch64_system = "aarch64-linux";
    allSystems = [x64_system x64_darwin aarch64_system];

    nixosSystem = import ./lib/nixosSystem.nix;
    darwinSystem = import ./lib/darwinSystem.nix;
    colmenaSystem = import ./lib/colmenaSystem.nix;

    x64_specialArgs =
      {
        inherit username userfullname useremail;
        pkgs-unstable = import nixpkgs-unstable {
          system = x64_system;
          config.allowUnfree = true;
          overlays = [custom-fonts.overlay];
        };
      }
      // inputs;

    rome_modules = {
      nixos-modules = [
        ./hosts/rome
        ./modules/desktop.nix
      ];
      home-module = import ./home/environments/desktop.nix;
    };

    venice_modules = {
      nixos-modules = [
        ./hosts/venice
      ];
      home-module = import ./home/environments/base.nix;
    };

    milan_modules = {
      nixos-modules = [
        ./hosts/milan
      ];
      home-module = import ./home/environments/base.nix;
    };
  in {
    nixosConfigurations = let
      base_args = {
        inherit home-manager;
        nixpkgs = nixpkgs;
        system = x64_system;
        specialArgs = x64_specialArgs;
      };
    in {
      rome = nixosSystem (rome_modules // base_args);
      milan = nixosSystem (milan_modules // base_args);
    };

    colmena = let
      base_args = {
        inherit home-manager;
        nixpkgs = nixpkgs;
        specialArgs = x64_specialArgs;
        targetUser = "root";
      };
    in {
      meta = {
        specialArgs = x64_specialArgs;
        nixpkgs = import nixpkgs {system = x64_system;};
      };
      venice = colmenaSystem (venice_modules // base_args);
      milan = colmenaSystem (milan_modules // base_args);
    };

    homeConfigurations = {
      "docchial@docchial-mn2" =
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./home/environments/work.nix ];
          extraSpecialArgs = {
            username = "docchial";
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin";
              config.allowUnfree = true;
            };
          } // inputs;
        };
    };
  };
}
