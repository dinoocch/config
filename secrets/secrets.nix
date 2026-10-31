let
  dino = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg5HANZD6fsxFVntwZidPReOhZ/ZDq10RMQIP8ozjGT";
  venice = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZAXkzh/H/IeQSfev+MMXF2aYoGm+RgRML9VMZLr96k";
in
{
  "cloudflare-api-token.age".publicKeys = [
    dino
    venice
  ];
  "zwave-js-keys.age".publicKeys = [
    dino
    venice
  ];
}
