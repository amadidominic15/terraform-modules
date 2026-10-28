resource "aws_s3_bucket" "s3_bucket" {
  for_each      = var.buckets
  bucket        = each.value.bucket_name
  force_destroy = each.value.force_destroy
  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name    = each.value.bucket_name
      Purpose = each.value.purpose
    }
  )
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.s3_bucket[each.key].id
  versioning_configuration {
    status = each.value.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  for_each = {
    for key, bucket in var.buckets : key => bucket
    if bucket.enable_encryption
  }
  bucket = aws_s3_bucket.s3_bucket[each.key].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = each.value.kms_key_arn == null ? "AES256" : "aws:kms"
      kms_master_key_id = each.value.kms_key_arn
    }
    bucket_key_enabled = each.value.kms_key_arn != null
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  for_each                = var.buckets
  bucket                  = aws_s3_bucket.s3_bucket[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket" {
  for_each = {
    for key, bucket in var.buckets : key => bucket
    if bucket.lifecycle_expiration_days != null
  }
  bucket = aws_s3_bucket.s3_bucket[each.key].id
  rule {
    id     = "expire-objects"
    status = "Enabled"
    filter {}
    expiration {
      days = each.value.lifecycle_expiration_days
    }
  }
  depends_on = [aws_s3_bucket_versioning.s3_bucket]
}
