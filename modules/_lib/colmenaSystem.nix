# colmena - Remote Deployment via SSH
{
  nixpkgs,
  home-manager,
  specialArgs,
  nixos-modules,
  home-module ? null,
  targetUser ? "root",
}:
let
  inherit (specialArgs) username;
in
{ name, nodes, ... }:
{
  deployment = {
    inherit targetUser;
    targetHost = name; # hostName or IP address
  };

  imports =
    nixos-modules
    ++ [
      {
        nix.registry.nixpkgs.flake = nixpkgs;
        environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
        nix.nixPath = [ "/etc/nix/inputs" ];
      }
    ]
    ++ (
      if (home-module != null) then
        [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              # home-manager manages this host's primary user, independent of
              # `targetUser` (the SSH/activation login, typically root).
              users."${username}" = home-module;
            };
          }
        ]
      else
        [ ]
    );
}
