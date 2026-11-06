output "secret_arns" {
  description = "Map of secret names to generated Secrets Manager ARNs."
  value = {
    for name, secret in aws_secretsmanager_secret.secret_manager :
    name => secret.arn
  }
}
output "kms_key_arns" {
  description = "Environment-specific KMS key ARNs"
  value = {
    for env, key in aws_kms_key.secrets :
    env => key.arn
  }
}

output "secret_names" {
  description = "Map of configured secret names."
  value = {
    for name, secret in aws_secretsmanager_secret.secret_manager :
    name => secret.name
  }
}
