variable "ecr_repositories" {
  description = "ECR repositories to create."
  type        = set(string)
  default     = []
}