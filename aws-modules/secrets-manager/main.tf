locals {
  secret_environments = toset([
    for name in keys(var.secrets) :
    split("/", name)[0]
  ])

  secrets = {
    for name, config in var.secrets :
    name => merge(config, {
      kms_key_id = coalesce(
        config.kms_key_id,
        aws_kms_key.secrets[split("/", name)[0]].arn
      )
    })
  }
}

resource "aws_kms_key" "secrets" {
  for_each = local.secret_environments
  description             = "${each.key} Secrets Manager encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name        = "${each.key}-secrets-kms"
    Environment = each.key
  }
}

resource "aws_secretsmanager_secret" "secret_manager" {
  for_each = local.secrets
  name                    = each.key
  description             = each.value.description
  kms_key_id              = each.value.kms_key_id
  recovery_window_in_days = each.value.recovery_window_in_days
}
