{ lib, config, ... }:
with lib;
let
  mountsFileSystemType = fsType: { } != filterAttrs (n: v: v.fsType == fsType) config.fileSystems;
  cfg = config.dino.prometheus;
in
{
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors =
            [
              "arp"
              "bcache"
              "conntrack"
              "filefd"
              "logind"
              "netclass"
              "netdev"
              "netstat"
              "sockstat"
              "softnet"
              "stat"
              "systemd"
              "textfile"
              "textfile.directory /run/prometheus-node-exporter"
              "thermal_zone"
              "time"
              "udp_queues"
              "uname"
              "vmstat"
            ]
            ++ optionals (!config.boot.isContainer) [
              "cpu"
              "cpufreq"
              "diskstats"
              "edac"
              "entropy"
              "filesystem"
              "hwmon"
              "interrupts"
              "ksmd"
              "loadavg"
              "meminfo"
              "pressure"
              "timex"
            ]
            ++ (optionals config.services.nfs.server.enable [ "nfsd" ])
            ++ (optionals ("" != config.boot.swraid.mdadmConf) [ "mdadm" ])
            ++ (optionals ({ } != config.networking.bonds) [ "bonding" ])
            ++ (optionals (mountsFileSystemType "nfs") [ "nfs" ])
            ++ (optionals (mountsFileSystemType "xfs") [ "xfs" ])
            ++ (optionals (mountsFileSystemType "zfs") [ "zfs" ]);
        };

        nginx = mkIf config.dino.server.enable { enable = true; };
        nginxlog = mkIf config.dino.server.enable {
          enable = true;
          user = "nginx";
          group = "nginx";

          settings = {
            parser = "json";
            namespaces =
              let
                mkApp = domain: {
                  name = domain;
                  parser = "json";
                  metrics_override = {
                    prefix = "nginxlog";
                  };
                  source.files = [ "/var/log/nginx/${domain}.access.log" ];
                  namespace_label = "vhost";
                };
              in
              [
                {
                  name = "catch";
                  parser = "json";
                  metrics_override = {
                    prefix = "nginxlog";
                  };
                  source.files = [ "/var/log/nginx/access.log" ];
                  namespace_label = "vhost";
                }
              ]
              ++ builtins.map mkApp (builtins.attrNames config.services.nginx.virtualHosts);
          };
        };
      };
    };
  };
}
