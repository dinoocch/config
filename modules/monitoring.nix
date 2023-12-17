{lib, config, ...}:

with lib;

let
  mountsFileSystemType = fsType: {} != filterAttrs (n: v: v.fsType == fsType) config.fileSystems;
  machineSupportsFileSystemZfs = config: elem "zfs" config.boot.supportedFilesystems;
  supportsFileSystemZfs = machineSupportsFileSystemZfs config;
in {
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
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
        ] ++ optionals (!config.boot.isContainer) [
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
        ] ++ (
          optionals (config.services.nfs.server.enable) [ "nfsd" ]
        ) ++ (
          optionals ("" != config.boot.swraid.mdadmConf) [ "mdadm" ]
        ) ++ (
          optionals ({} != config.networking.bonds) [ "bonding" ]
        ) ++ (
          optionals (mountsFileSystemType "nfs") [ "nfs" ]
        ) ++ (
          optionals (mountsFileSystemType "xfs") [ "xfs" ]
        ) ++ (
          optionals (supportsFileSystemZfs) [ "zfs" ]
        );
      };
    };
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [{
        url = "http://10.1.1.80:3030/loki/api/v1/push";
      }];
      scrape_configs = [{
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = {
            job = "systemd-journal";
            host = "${config.networking.hostName}";
          };
        };
        relabel_configs = [{
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }];
      }];
    };
  };
}
