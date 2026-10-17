variable "secrets" {
  description = "Secret containers to create. Secret values are added separately."
  type = map(object({
    description             = optional(string, "")
    kms_key_id              = optional(string)
    recovery_window_in_days = optional(number, 30)
  }))

  validation {
    condition = alltrue([
      for secret in values(var.secrets) :
      secret.recovery_window_in_days >= 7 &&
      secret.recovery_window_in_days <= 30
    ])
    error_message = "Recovery window must be between 7 and 30 days."
  }
}
