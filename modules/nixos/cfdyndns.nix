{
  config.nixos.modules.cfdyndns =
    { config, ... }:
    {
      services.cfdyndns = {
        enable = false;
        email = "dino.occhialini@gmail.com";
        records = [ config.dino.server.domain ];
        # TODO: Create some private age encrypted secrets flake
        apikeyFile = "/etc/cfdns-token";
      };
    };
}
