{pkgs, ...}: {
  imports = [
    ./starship.nix
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
    '';
  };
  programs.starship.enableFishIntegration = true;
}
