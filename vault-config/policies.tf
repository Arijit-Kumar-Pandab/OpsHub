# ---------------------------------------------------------
# OpsHub API Vault Policy
# ---------------------------------------------------------

resource "vault_policy" "opshub_api" {
  name = "opshub-api"

  policy = <<-EOT
    # Read the API application's secret data
    path "opshub-secrets/data/api" {
      capabilities = ["read"]
    }

    # Read metadata for the API secret
    path "opshub-secrets/metadata/api" {
      capabilities = ["read"]
    }
  EOT
}