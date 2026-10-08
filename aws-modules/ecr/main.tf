resource "aws_ecr_repository" "ecr" {
  for_each = var.ecr_repositories
  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability
  force_delete         = each.value.force_delete
  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    Name = each.key
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = var.ecr_repositories
  repository = aws_ecr_repository.ecr[each.key].name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description = "Keep the last 30 images"
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