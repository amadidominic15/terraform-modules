resource "aws_s3_bucket" "loki" {
  count = var.enable_loki ? 1 : 0
  bucket = "${var.cluster_name}-terraform-loki-2026"
  tags = {
    Name        = "${var.cluster_name}-loki"
    Purpose     = "Loki storage"
    Environment = "loki"
  }
}

resource "aws_s3_bucket_versioning" "loki" {
  count = var.enable_loki ? 1 : 0
  bucket = aws_s3_bucket.loki[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "loki" {
  count = var.enable_loki ? 1 : 0
  bucket = aws_s3_bucket.loki[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "loki" {
  count = var.enable_loki ? 1 : 0
  bucket = aws_s3_bucket.loki[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}