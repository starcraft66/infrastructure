{ config, lib, pkgs, ... }:

let
  # Address of 235-gw on the other side of wg0 to hit its blackbox_exporter
  tunnel235Address = "2a0c:9a46:636:f0::1";
  # The actual shit to monitor
  icmpTargets = [
    "235.tdude.co" # 235
    "305-1700.tdude.co" # 305-1700
  ];

  httpTargets = [
    "example.com"
  ];

  sshTargets235 = [
    "stormfeather.235.tdude.co:22"
    "soarin.235.tdude.co:22"
    "sassaflash.235.tdude.co:22"
    "spitfire.235.tdude.co:22"
    "firestreak.235.tdude.co:22"
  ];

  # https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md
  blackboxConfig = {
    modules = {
      http_2xx = {
        prober = "http";
        timeout = "5s";
        http = {
          method = "GET";
          valid_status_codes = [ ]; # Defaults to 2xx
          follow_redirects = true;
        };
      };

      icmp = {
        prober = "icmp";
        timeout = "5s";
      };
    };
  };

  alertRules = builtins.toJSON {
    groups = [
      {
        name = "tdude_monitoring";
        rules = [
          # Alert for HTTP Probe - fires if HTTP probe fails
          {
            alert = "HttpProbeDown";
            expr = ''
              probe_success{job="http_probe"} == 0
            '';
            for = "1m";
            labels = {
              severity = "critical";
            };
            annotations = {
              summary = "HTTP probe failed for target {{ $labels.instance }}";
              description = "The HTTP probe for target {{ $labels.instance }} has failed for over 1 minute.";
            };
          }

          # Alert for ICMP Probe - fires if ICMP probe fails
          {
            alert = "IcmpProbeDown";
            expr = ''
              probe_success{job="icmp_probe"} == 0
            '';
            for = "1m";
            labels = {
              severity = "critical";
            };
            annotations = {
              summary = "ICMP probe failed for target {{ $labels.instance }}";
              description = "The ICMP probe for target {{ $labels.instance }} has failed for over 1 minute.";
            };
          }

          # Alert for Slow HTTP Response - fires if HTTP latency exceeds threshold
          {
            alert = "HttpProbeSlowResponse";
            expr = ''
              probe_duration_seconds{job="http_probe"} > 0.5
            '';
            for = "5m";
            labels = {
              severity = "warning";
            };
            annotations = {
              summary = "Slow HTTP response detected for target {{ $labels.instance }}";
              description = "The HTTP probe response time for target {{ $labels.instance }} has exceeded 500ms for 5 minutes.";
            };
          }

          # Alert for High ICMP Latency - fires if ICMP latency exceeds threshold
          {
            alert = "IcmpProbeHighLatency";
            expr = ''
              probe_duration_seconds{job="icmp_probe"} > 0.2
            '';
            for = "5m";
            labels = {
              severity = "warning";
            };
            annotations = {
              summary = "High ICMP latency detected for target {{ $labels.instance }}";
              description = "The ICMP probe response time for target {{ $labels.instance }} has exceeded 200ms for 5 minutes.";
            };
          }

          # Alert for SSH Probe - fires if SSH probe fails
          {
            alert = "SshProbe235GwDown";
            expr = ''
              probe_success{job="ssh_probe_235-gw"} == 0
            '';
            for = "1m";
            labels = {
              severity = "critical";
            };
            annotations = {
              summary = "SSH probe failed for target {{ $labels.instance }}";
              description = "The SSH probe for target {{ $labels.instance }} has failed for over 1 minute.";
            };
          }
        ];
      }
    ];
  };
in {
  services.nginx = {
    virtualHosts = {
      ${config.services.grafana.settings.server.domain} = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
          '';
        };
      };
    };
  };

  services.grafana = {
    enable = true;
    provision.datasources.settings.datasources = [
      {
        type = "prometheus";
        url = "http://localhost:${toString config.services.prometheus.port}";
        name = "Prometheus";
      }
    ];
    settings.server = {
      domain = "monitoring.tdude.co";
      http_port = 3000;
      http_addr = "::1";
    };
  };

  services.prometheus.exporters.blackbox = {
    enable = true;
    port = 9115;
    configFile = pkgs.writeText "blackbox.json" (builtins.toJSON blackboxConfig);
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    alertmanagers = [
      {
        scheme = "http";
        path_prefix = "/";
        static_configs = [
          {
            targets = [
              "[::1]:9093"
            ];
          }
        ];
      }
    ];
    scrapeConfigs = let
      mkRelabelConfigs = host: port: [
        {
          source_labels = [ "__address__" ];
          target_label = "__param_target";
        }
        {
          source_labels = [ "__param_target" ];
          target_label = "instance";
        }
        {
          target_label = "__address__";
          replacement = "${host}:${toString port}";
        }
      ];
      in [
      {
        job_name = "node";
        scrape_interval = "1m";
        static_configs = [{
          targets = [
            "localhost:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
      {
        job_name = "http_probe";
        metrics_path = "/probe";
        scrape_interval = "15s";
        params.module = [ "http_2xx" ];
        static_configs = [{
          targets = httpTargets;
        }];
        relabel_configs = mkRelabelConfigs "localhost" 9115;
      }
      {
        job_name = "icmp_probe";
        metrics_path = "/probe";
        scrape_interval = "10s";
        params.module = [ "icmp" ];
        static_configs = [{
          targets = icmpTargets;
        }];
        relabel_configs = mkRelabelConfigs "localhost" 9115;
      }
      {
        job_name = "ssh_probe_235-gw";
        metrics_path = "/probe";
        scrape_interval = "10s";
        params.module = [ "ssh_banner" ];
        static_configs = [{
          targets = sshTargets235;
        }];

        relabel_configs = mkRelabelConfigs "[${tunnel235Address}]" 9115;
      }
    ];
  };

  services.prometheus.alertmanager = {
    enable = true;
    listenAddress = "[::1]";
    extraFlags = [ "--cluster.listen-address=[::1]:9094" ];
    configuration = {
      global.resolve_timeout = "5m";
      templates = [ "/etc/alertmanager/template/*.tmpl" ];
      route = {
        group_by = [ "hostname" "alertname" ];
        group_wait = "30s";
        group_interval = "5m";
        repeat_interval = "5m";
        receiver = "discord_webhook";
      };
      receivers = [
        {
          name = "discord_webhook";
          webhook_configs = [
            {
              url = "http://localhost:9095";
            }
          ];
        }
        {
          name = "default";
        }
      ];
    };
  };

  services.prometheus.rules = [ alertRules ];
  sops.secrets.monitoring-webhook = { };
  services.alertmanager-discord.enable = true;
  services.alertmanager-discord.webhookFile = config.sops.secrets.monitoring-webhook.path;
}