
resource "aws_secretsmanager_secret" "secret_manager" {
  for_each = var.secrets

  name                    = each.key
  description             = each.value.description
  kms_key_id              = each.value.kms_key_id
  recovery_window_in_days = each.value.recovery_window_in_days

  tags = {
    ManagedBy = "Terraform"
  }
}
