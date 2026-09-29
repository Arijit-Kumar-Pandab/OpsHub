# ---------------------------------------------------------
# OpsHub API Kubernetes Auth Role
# ---------------------------------------------------------

resource "vault_kubernetes_auth_backend_role" "opshub_api" {
  backend = vault_auth_backend.kubernetes.path

  role_name = "opshub-api"

  bound_service_account_names = [
    var.opshub_api_service_account
  ]

  bound_service_account_namespaces = [
    var.opshub_namespace
  ]

  token_policies = [
    vault_policy.opshub_api.name
  ]

  token_ttl     = 3600
  token_max_ttl = 7200

  token_no_default_policy = true
}