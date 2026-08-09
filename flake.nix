{
  description = "Various NixOS and home-manager configs";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Dendritic pattern plumbing
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix/release-26.05";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    # wezterm = {
    #   url = "github:wez/wezterm?dir=nix";
    # };
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # microvm.url = "github:astro/microvm.nix";
    # microvm.inputs.nixpkgs.follows = "nixpkgs";
    conduit = {
      url = "gitlab:famedly/conduit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    download-buffer-size = 268435456;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://install.determinate.systems"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
    ];
  };

  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (import-tree ./modules)
        (import-tree ./hosts)
      ];
    };
}
