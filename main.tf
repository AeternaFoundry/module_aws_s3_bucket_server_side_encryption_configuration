resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_server_side_encryption_configurations" {
  for_each = var.s3_bucket_server_side_encryption_configurations

  bucket                = each.value.bucket
  expected_bucket_owner = each.value.expected_bucket_owner
  region                = each.value.region

  dynamic "rule" {
    for_each = each.value.rule
    content {
      dynamic "apply_server_side_encryption_by_default" {
        for_each = rule.value.apply_server_side_encryption_by_default != null ? [rule.value.apply_server_side_encryption_by_default] : []
        content {
          kms_master_key_id = apply_server_side_encryption_by_default.value.kms_master_key_id
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
        }
      }
      blocked_encryption_types = rule.value.blocked_encryption_types
      bucket_key_enabled       = rule.value.bucket_key_enabled
    }
  }
}

