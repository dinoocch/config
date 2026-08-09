{
  config.nixos.modules.docker = _: {
    virtualisation.containers.storage.settings = {
      storage = {
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };
  };
}
