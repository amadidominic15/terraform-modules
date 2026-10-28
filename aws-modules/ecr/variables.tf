variable "project" {
  description = "Common prefix for resource names"
  type        = string
}
variable "repository_names" {
  description = "ECR repositories to create."
  type        = set(string)
  default     = []
}
variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
