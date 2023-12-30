{
  description = "Various NixOS and home-manager configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
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
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Is this even worth it lol
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
    catppuccin-rofi = {
      url = "github:catppuccin/rofi";
      flake = false;
    };
    catppuccin-qt5ct = {
      url = "github:catppuccin/qt5ct";
      flake = false;
    };

    conduit = {
        url = "gitlab:famedly/conduit";
        # inputs.nixpkgs.follows = "nixpkgs";
    };

    # rk3588 - TODO: Probably needs to use a fork for now?
    nixos-rk3588 = { 
      url = "github:ryan4yin/nixos-rk3588";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixos-rk3588,
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
      rk3588_pkgs = import nixos-rk3588.inputs.nixpkgs {system = x64_system;};
      rk3588_specialArgs = {
        inherit username userfullname useremail conduit;
      } // nixos-rk3588.inputs;
      rk3588_base_args = {
        inherit home-manager;
        nixpkgs = nixos-rk3588.inputs.nixpkgs; # or nixpkgs-unstable
        specialArgs = rk3588_specialArgs;
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
  };
}
