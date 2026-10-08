variable "cluster_name" {
  description = "Name used to identify resources belonging to the cluster."
  type = string
}
variable "enable_loki" {
  description = "Whether to create an S3 bucket for Loki."
  type    = bool
  default = true
}