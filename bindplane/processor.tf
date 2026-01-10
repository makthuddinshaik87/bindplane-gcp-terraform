resource "bindplane_processor" "batch" {
  rollout = true
  name    = "batch-copy-v2"
  type    = "batch"

  parameters_json = jsonencode([
    { name = "send_batch_size", value = 200 },
    { name = "send_batch_max_size", value = 400 },
    { name = "timeout", value = "5s" }
  ])
}