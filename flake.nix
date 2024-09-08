{
  description = "Various NixOS and home-manager configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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

    catppuccin.url = "github:catppuccin/nix";
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
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      conduit,
      custom-fonts,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      username = "dino";
      userfullname = "Dino Occhialini";
      useremail = "dino.occhialini@gmail.com";

      x64_system = "x86_64-linux";
      nixosSystem = import ./lib/nixosSystem.nix;
      colmenaSystem = import ./lib/colmenaSystem.nix;

      x64_specialArgs = {
        inherit
          username
          userfullname
          useremail
          inputs
          ;
        pkgs = import nixpkgs {
          system = x64_system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import nixpkgs-unstable {
          system = x64_system;
          config.allowUnfree = true;
          overlays = [ custom-fonts.overlay ];
        };
      };

      rome_modules = {
        nixos-modules = [
          ./hosts/rome
          ./modules/nixos
          ./modules/roles/desktop.nix
        ];
        home-module = import ./hosts/rome/home.nix;
      };

      venice_modules = {
        nixos-modules = [
          ./hosts/venice
          ./modules/nixos
        ];
        home-module = import ./hosts/venice/home.nix;
      };

      milan_modules = {
        nixos-modules = [
          ./hosts/milan
          ./modules/nixos
        ];
        home-module = import ./hosts/milan/home.nix;
      };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      nixosConfigurations =
        let
          base_args = {
            inherit home-manager nixpkgs;
            system = x64_system;
            specialArgs = x64_specialArgs;
          };
        in
        {
          rome = nixosSystem (rome_modules // base_args);
          milan = nixosSystem (milan_modules // base_args);
        };

      colmena =
        let
          base_args = {
            inherit home-manager nixpkgs;
            specialArgs = x64_specialArgs;
            targetUser = "root";
          };
        in
        {
          meta = {
            specialArgs = x64_specialArgs;
            nixpkgs = import nixpkgs { system = x64_system; };
          };
          venice = colmenaSystem (venice_modules // base_args);
          milan = colmenaSystem (milan_modules // base_args);
        };

      homeConfigurations = {
        "docchial@docchial-mn2" = inputs.home-manager.lib.homeManagerConfiguration {
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

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
            statix.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });
    };
}
