{
  description = "Various NixOS and home-manager configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # home-manager for non-system configs
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    }

    # try wayland for now idk? otherwise I will go back to bspwm
    hyperland.url = "github:hyprwm/Hyprland/v0.28.0";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };
    # Is this even worth it lol
    catppuccin-waybar = {
      url = "github:catppuccin/waybar";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };

    # rk3588 - TODO: Probably needs to use a fork for now?
    niksos-rk3588.url = "github:ryan4yin/nixos-rk3588";
  }

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org"
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs = inputs @ {
    self,
    nixpkgs,
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
        };
      }
      // inputs;

    rome_modules = {
      nixos-modules = [
        ./hosts/rome
      ];
      home-module = import ./home/desktop;
    };
  in {
    nixosConfigurations = let
      base_args = {
        inherit home-manager;
        nixpkgs = nixpkgs; # or nixpkgs-unstable?
        system = x64_system;
        specialArgs = x64_specialArgs;
      };
    in {
      rome = nixosSystem (rome_modules // base_args)
    };
  };
}
