# ---------------------------------------------------------
# KMS Key for Vault Auto-Unseal
# ---------------------------------------------------------

resource "aws_kms_key" "vault" {
  description             = "KMS key for OpsHub Vault auto-unseal"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  tags = {
    Name = "${local.name_prefix}-vault-kms"
  }
}

resource "aws_kms_alias" "vault" {
  name          = "alias/${local.name_prefix}-vault"
  target_key_id = aws_kms_key.vault.key_id
}