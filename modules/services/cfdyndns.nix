{
  config.nixos.modules.cfdyndns =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      apiToken = ../../secrets/cloudflare-api-token.age;
      hasApiToken = builtins.pathExists apiToken;
      cfg = config.services.cfdyndns;
      updateCloudflareDns = pkgs.writeShellApplication {
        name = "update-cloudflare-dns";
        runtimeInputs = with pkgs; [
          curl
          jq
        ];
        text = ''
          set -euo pipefail

          auth_file="$RUNTIME_DIRECTORY/curl.conf"
          printf 'header = "Authorization: Bearer %s"\nheader = "Content-Type: application/json"\n' \
            "$(<"$CREDENTIALS_DIRECTORY/cloudflare-api-token")" > "$auth_file"

          api() {
            local response
            response=$(curl --silent --show-error --fail-with-body --config "$auth_file" "$@")
            if ! jq -e '.success == true' <<< "$response" >/dev/null; then
              jq -c '{errors, messages}' <<< "$response" >&2
              return 1
            fi
            printf '%s\n' "$response"
          }

          zone_response=$(api --get \
            --data-urlencode "name=${config.dino.server.domain}" \
            --data-urlencode "status=active" \
            "https://api.cloudflare.com/client/v4/zones")
          zone_count=$(jq '.result | length' <<< "$zone_response")
          if [[ "$zone_count" -ne 1 ]]; then
            echo "Expected exactly one active Cloudflare zone for ${config.dino.server.domain}, found $zone_count" >&2
            exit 1
          fi
          zone_id=$(jq -r '.result[0].id' <<< "$zone_response")

          update_record() {
            local type=$1
            local name=$2
            local address=$3
            local records_response record_count record_id current_address payload

            records_response=$(api --get \
              --data-urlencode "type=$type" \
              --data-urlencode "name=$name" \
              "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records")
            record_count=$(jq '.result | length' <<< "$records_response")

            case "$record_count" in
              0)
                payload=$(jq -nc \
                  --arg type "$type" \
                  --arg name "$name" \
                  --arg content "$address" \
                  '{type: $type, name: $name, content: $content, ttl: 1, proxied: false}')
                api --request POST --data "$payload" \
                  "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records" >/dev/null
                echo "Created $type record $name"
                ;;
              1)
                record_id=$(jq -r '.result[0].id' <<< "$records_response")
                current_address=$(jq -r '.result[0].content' <<< "$records_response")
                if [[ "$current_address" != "$address" ]]; then
                  payload=$(jq -nc --arg content "$address" '{content: $content}')
                  api --request PATCH --data "$payload" \
                    "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" >/dev/null
                  echo "Updated $type record $name"
                fi
                ;;
              *)
                echo "Expected at most one $type record for $name, found $record_count" >&2
                return 1
                ;;
            esac
          }

          ipv4=$(curl --silent --show-error --fail --ipv4 https://cloudflare.com/cdn-cgi/trace |
            sed -n 's/^ip=//p')
          [[ -n "$ipv4" ]] || {
            echo "Could not determine the public IPv4 address" >&2
            exit 1
          }

          ipv6=""
          if ipv6_trace=$(curl --silent --show-error --fail --ipv6 https://cloudflare.com/cdn-cgi/trace 2>/dev/null); then
            ipv6=$(sed -n 's/^ip=//p' <<< "$ipv6_trace")
          else
            echo "No public IPv6 address detected; leaving AAAA records unchanged" >&2
          fi

          records=( ${lib.escapeShellArgs cfg.records} )
          for record in "''${records[@]}"; do
            update_record A "$record" "$ipv4"
            if [[ -n "$ipv6" ]]; then
              update_record AAAA "$record" "$ipv6"
            fi
          done
        '';
      };
    in
    {
      imports = [ inputs.agenix.nixosModules.default ];

      age.secrets.cloudflare-api-token = lib.mkIf hasApiToken {
        file = apiToken;
        mode = "0400";
      };

      services.cfdyndns = {
        enable = false;
        email = "dino.occhialini@gmail.com";
        records = [ config.dino.server.domain ];
      };

      security.acme.defaults = lib.mkIf hasApiToken {
        credentialFiles.CF_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-api-token.path;
      };
      security.acme.certs = lib.mkIf hasApiToken (
        lib.genAttrs cfg.records (_: {
          dnsProvider = "cloudflare";
          webroot = lib.mkForce null;
        })
      );

      systemd = lib.mkIf hasApiToken {
        services.cloudflare-dyndns = {
          description = "Update Cloudflare dynamic DNS records";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            Type = "oneshot";
            DynamicUser = true;
            RuntimeDirectory = "cloudflare-dyndns";
            LoadCredential = "cloudflare-api-token:${config.age.secrets.cloudflare-api-token.path}";
            ExecStart = lib.getExe updateCloudflareDns;
          };
        };

        timers.cloudflare-dyndns = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1min";
            OnUnitActiveSec = "5min";
            RandomizedDelaySec = "30s";
            Unit = "cloudflare-dyndns.service";
          };
        };
      };
    };
}
