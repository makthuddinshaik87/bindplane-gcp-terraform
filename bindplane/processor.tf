resource "bindplane_processor" "batch" {
  name = "batch-copy-v2"
  type = "batch"

  configuration = jsonencode({
    batch_size = 1000
    timeout    = "5s"
  })
}