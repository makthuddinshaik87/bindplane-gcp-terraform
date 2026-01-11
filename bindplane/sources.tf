resource "bindplane_source" "journald_logs" {
  name = "journald-logs-copy-v2"
  type = "journald"

  configuration = jsonencode({
    include_units = ["docker.service"]
  })
}

resource "bindplane_source" "host_metrics" {
  name = "host-metrics-copy-v2"
  type = "host_metrics"

  configuration = jsonencode({})
}