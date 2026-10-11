variable "s3_bucket_server_side_encryption_configurations" {
  description = <<EOT
Map of s3_bucket_server_side_encryption_configurations, attributes below
Required:
    - bucket
    - rule (block):
        - apply_server_side_encryption_by_default (optional, block):
            - kms_master_key_id (optional)
            - sse_algorithm (required)
        - blocked_encryption_types (optional)
        - bucket_key_enabled (optional)
Optional:
    - expected_bucket_owner
    - region
EOT

  type = map(object({
    bucket                = string
    expected_bucket_owner = optional(string)
    region                = optional(string)
    rule = list(object({
      apply_server_side_encryption_by_default = optional(object({
        kms_master_key_id = optional(string)
        sse_algorithm     = string
      }))
      blocked_encryption_types = optional(list(string))
      bucket_key_enabled       = optional(bool)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.s3_bucket_server_side_encryption_configurations : (
        length(v.rule) >= 1
      )
    ])
    error_message = "Each rule list must contain at least 1 items"
  }
  # Note: 4 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

