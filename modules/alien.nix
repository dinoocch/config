{ self, system, nix-alien, ... }: {
  environment.systemPackages = with nix-alien.packages.${system}; [
    nix-alien
  ];
  programs.nix-ld.enable = true;
}
