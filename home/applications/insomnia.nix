{pkgs, ...}: {
  home.packages = with pkgs; [
    insomnia
  ];

  # TODO: Figure out how to configure insomnia...In the meantime, add insomnia-plugin-catppuccin theme manually
}
