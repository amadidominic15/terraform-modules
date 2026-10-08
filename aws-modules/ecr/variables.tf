variable "ecr_repositories" {
  description = "ECR repositories to create."
  type = map(object({
    image_tag_mutability = optional(string, "IMMUTABLE")
    scan_on_push         = optional(bool, true)
    force_delete         = optional(bool, false)
  }))
  default = {}
}