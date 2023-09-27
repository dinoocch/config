{username, ...}: {
  nix.settings.trusted-users = [username];
  users.groups = {
    "${username}" = {};
    "docker" = {};
  };
  users.users."${username}" = {
    home = "/home/${username}";
    isNormalUser = true;
    description = username;
    extraGroups = [
      username
      "users"
      "networkmanager"
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaADz4VrsCbyI5au/HeE0EK5VIS/Ffcso/3V/vK7fyc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlyJkL8MaMzVP6LOt1Pz2V/sA3ys2L1RCU3rRyaQU6K"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaADz4VrsCbyI5au/HeE0EK5VIS/Ffcso/3V/vK7fyc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg5HANZD6fsxFVntwZidPReOhZ/ZDq10RMQIP8ozjGT"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [username];
      commands = [
        {
          command = "/run/current-system/sw/bin/nix-store";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nix-copy-closure";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
