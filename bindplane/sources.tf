resource "bindplane_source" "host_metrics" {
  rollout = true
  name    = "host-metrics-copy-v2"
  type    = "host"

  parameters_json = jsonencode([
    { name = "collection_interval", value = 60 },
    { name = "enable_process", value = true }
  ])
}

resource "bindplane_source" "journald_logs" {
  rollout = true
  name    = "journald-logs-copy-v2"
  type    = "journald"
}