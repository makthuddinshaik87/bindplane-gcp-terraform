resource "bindplane_configuration" "logs" {
  rollout  = true
  name     = "bindplane-agent-vm-logs"
  platform = "linux"

  source {
    name       = bindplane_source.journald_logs.name
    processors = [bindplane_processor.batch.name]
  }

  destination {
    name = "googlebucket"
  }
}

resource "bindplane_configuration" "metrics" {
  rollout  = true
  name     = "bindplane-agent-vm-metrics"
  platform = "linux"

  source {
    name       = bindplane_source.host_metrics.name
    processors = [bindplane_processor.batch.name]
  }

  destination {
    name = "googlebucket"
  }
}