{
  config.homeManager.modules.llm =
    {
      config,
      lib,
      inputs,
      pkgs-unstable,
      ...
    }:
    {
      home.packages = with inputs.llm-agents.packages.${pkgs-unstable.stdenv.hostPlatform.system}; [
        pi
        copilot-cli
      ];
    };
}
