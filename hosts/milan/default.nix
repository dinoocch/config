{lib, config, username, ...} @ args:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/user-group.nix
    ../../modules/server.nix
  ];

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    # "zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "cifs"
  ];

  users.users.root.openssh.authorizedKeys.keys = config.users.users."${username}".openssh.authorizedKeys.keys;

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
  };

  networking = {
    hostName = "milan";

    enableIPv6 = true;

    # WAN Port
    interfaces.enp2s0 = {
      useDHCP = true;
    };

    # Ports
    interfaces.enp3s0 = {
      useDHCP = false;
      ipv4.addresses = [{
         address = "10.1.1.1";
         prefixLength = 24;
      }];
    };
    interfaces.enp4s0 = {
      useDHCP = false;
      ipv4.addresses = [{
         address = "10.1.2.1";
         prefixLength = 24;
      }];
    };
    interfaces.enp5s0 = {
      useDHCP = false;
      ipv4.addresses = [{
         address = "10.1.3.1";
         prefixLength = 24;
      }];
    };

    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];

    nat.enable = false;
    firewall.enable = false;
    # TODO: Someday use vlans instead of this
    nftables = {
      enable = true;
      checkRuleset = false;
      ruleset = ''
        table inet filter {
          flowtable f {
            hook ingress priority filter
            devices = { "enp2s0", "enp3s0" };
          }

          chain output {
            type filter hook output priority 100; policy accept;
          }

          chain input {
            type filter hook input priority 0; policy drop;
            tcp dport { 22, 80, 443 } counter accept
            iifname { "enp3s0" } counter accept comment "lan -> router"
            iifname { "enp2s0" } ct state { established, related } counter accept
            iifname { "enp2s0" } icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
            iifname { "enp2s0" } counter drop comment "Drop unsolicited inbound traffic"
          }

          chain forward {
            type filter hook forward priority 0; policy drop;

            ip protocol { tcp, udp } flow offload @f;
            ip6 nexthdr { tcp, udp } flow offload @f;

            iifname { "enp3s0", "enp4s0", "enp5s0" } oifname { "enp2s0" } accept comment "local -> wan"
            iifname { "enp2s0" } oifname { "enp3s0", "enp4s0", "enp5s0" } ct state { established, related } accept comment "wan -> lan"
            iifname { "enp3s0", "enp4s0" } oifname { "enp5s0" } counter accept comment "local -> iot"
            iifname { "enp5s0" } oifname { "enp3s0", "enp4s0" } ct state { established, related } counter accept comment "iot -> local"
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority 100; policy accept;
          }

          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "enp2s0" masquerade
          }
        }
      '';
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  systemd.services.nftables.before = lib.mkForce [];
  systemd.services.nftables.after = [ "network-pre.target" ];

  # Unbound DNS
  services.unbound = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = [
        "127.0.0.1"
        "10.1.1.1"
        "10.1.2.1"
        "10.1.3.1"
      ];
      access-control = [
        "0.0.0.0/0 refuse"
        "127.0.0.0/8 allow"
        "10.0.0.0/8 allow"
      ];
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [
      "enp3s0"
      "enp4s0"
      "enp5s0"
    ];

    machines = [
      {
        hostName = "rome";
        ipAddress = "10.1.1.69";
        ethernetAddress = "18:c0:4d:09:d5:cd";
      }
      {
        hostName = "rome-1g";
        ipAddress = "10.1.1.68";
        ethernetAddress = "18:c0:4d:09:d5:cc";
      }
    ];

    extraConfig = ''
      option subnet-mask 255.255.255.0;
      default-lease-time 2592000;
      max-lease-time 2592000;

      subnet 10.1.1.0 netmask 255.255.255.0 {
        interface enp3s0;
        range 10.1.1.10 10.1.1.60;
        option routers 10.1.1.1;
        option domain-name-servers 10.1.1.1;
        option broadcast-address 10.1.1.255;
      }

      subnet 10.1.2.0 netmask 255.255.255.0 {
        interface enp4s0;
        range 10.1.2.10 10.1.2.254;
        option routers 10.1.2.1;
        option domain-name-servers 10.1.2.1;
        option broadcast-address 10.1.2.255;
      }

      subnet 10.1.3.0 netmask 255.255.255.0 {
        interface enp5s0;
        range 10.1.3.10 10.1.3.254;
        option routers 10.1.3.1;
        option domain-name-servers 8.8.8.8;
        option broadcast-address 10.1.3.255;
      }
    '';
  };

  networking.dhcpcd = {
    enable = true;
    persistent = true;
    allowInterfaces = [ "enp2s0" ];
    extraConfig = ''
      nohook resolv.conf
      duid
      slaac private
      noipv6rs

      interface enp2s0
        ipv6rs
        ia_na 1
        ia_pd 2/::/60 enp3s0/0/64 enp4s0/1/64 enp5s0/4/64
    '';
  };

  # TODO; Add miniupnpd if it ends up being too much of a hassle

  system.stateVersion = "23.05";
}