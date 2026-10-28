resource "aws_ecr_repository" "ecr" {
  for_each             = var.repository_names
  name                 = "${var.project}-${each.value}"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false #protects repositories from Terraform deleting them while they contain images.
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    Name = "${var.project}-${each.value}"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  for_each   = var.repository_names
  repository = aws_ecr_repository.ecr[each.value].name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the last 30 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}