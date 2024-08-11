{...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      character = {
        success_symbol = "[[♥](green) ❯](sky)";
        error_symbol = "[❯](red)";
        vicmd_symbol = "[❮](green)";
      };
    };
  };
}
