# colmena - Remote Deployment via SSH
{
  nixpkgs,
  home-manager,
  specialArgs,
  nixos-modules,
  home-module ? null,
  host_tags,
  targetUser ? specialArgs.username,
}: let
  username = specialArgs.username;
in
  { name, nodes, ... }: {
    deployment = {
      targetHost = name;  # hostName or IP address
      targetUser = targetUser;
      tags = host_tags;
    };

    imports =
      nixos-modules
      ++ [
        {
          nix.registry.nixpkgs.flake = nixpkgs;
          environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
          nix.nixPath = ["/etc/nix/inputs"];
        }
      ] ++ (if (home-module != null) then [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users."${username}" = home-module;
        }
      ] else []);
  }
