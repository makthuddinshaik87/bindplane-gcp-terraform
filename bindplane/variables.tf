variable "bindplane_address" {
  description = "BindPlane API base URL"
  type        = string
}

variable "bindplane_api_key" {
  description = "BindPlane API key"
  type        = string
  sensitive   = true
}