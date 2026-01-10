resource "bindplane_source" "journald_logs" {
  rollout = true
  name    = "journald-logs-copy-v2"
  type    = "journald"
}

resource "bindplane_source" "host_metrics" {
  rollout = true
  name    = "host-metrics-copy-v2"
  type    = "host"
} 