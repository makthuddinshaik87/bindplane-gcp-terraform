
################################
# Provider
################################
provider "bindplane" {
  remote_url = "http://34.136.148.87:3001"
  api_key    = "09ec7c66-9c36-4a0c-8623-1faee8820e2c"  # POC only
}

################################
# SOURCES (Unique Names)
################################
resource "bindplane_source" "host_metrics_v5" {
  rollout = true
  name    = "host-metrics-copy-v5"
  type    = "host"

  parameters_json = jsonencode([
    {
      name  = "collection_interval"
      value = 60
    },
    {
      name  = "enable_process"
      value = true
    }
  ])
}

resource "bindplane_source" "journald_logs_v5" {
  rollout = true
  name    = "journald-logs-copy-v5"
  type    = "journald"
}

################################
# PROCESSOR (Unique Name)
################################
resource "bindplane_processor" "batch_v5" {
  rollout = true
  name    = "batch-copy-v5"
  type    = "batch"

  parameters_json = jsonencode([
    {
      name  = "send_batch_size"
      value = 200
    },
    {
      name  = "send_batch_max_size"
      value = 400
    },
    {
      name  = "timeout"
      value = "5s"
    }
  ])
}

################################
# CONFIGURATION: LOGS
################################
resource "bindplane_configuration" "logs_config_v5" {
  rollout  = true
  name     = "bindplane-agent-vm-logs-v5"
  platform = "linux"

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }

  source {
    name       = bindplane_source.journald_logs_v5.name
    processors = [bindplane_processor.batch_v5.name]
  }

  destination {
    name = "googlebucket"   # existing bucket
  }
}

################################
# CONFIGURATION: METRICS
################################
resource "bindplane_configuration" "metrics_config_v5" {
  rollout  = true
  name     = "bindplane-agent-vm-metrics-v5"
  platform = "linux"

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }

  source {
    name       = bindplane_source.host_metrics_v5.name
    processors = [bindplane_processor.batch_v5.name]
  }

  destination {
    name = "googlebucket"   # same bucket
  }
}
