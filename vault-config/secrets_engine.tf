# ---------------------------------------------------------
# OpsHub KV Version 2 Secrets Engine
# ---------------------------------------------------------

resource "vault_mount" "opshub_secrets" {
  path = "opshub-secrets"

  type = "kv"

  options = {
    version = "2"
  }

  description = "OpsHub application secrets"
}

resource "vault_kv_secret_backend_v2" "opshub_secrets" {
  mount = vault_mount.opshub_secrets.path

  max_versions         = 10
  delete_version_after = 0
  cas_required         = true

  depends_on = [
    vault_mount.opshub_secrets
  ]
}