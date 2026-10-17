output "secret_arns" {
  description = "Map of secret names to generated Secrets Manager ARNs."
  value = {
    for name, secret in aws_secretsmanager_secret.secret_manager :
    name => secret.arn
  }
}

output "secret_names" {
  description = "Map of configured secret names."
  value = {
    for name, secret in aws_secretsmanager_secret.secret_manager :
    name => secret.name
  }
}
