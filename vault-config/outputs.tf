output "opshub_api_vault_policy" {
  description = "Vault policy assigned to the OpsHub API workload"
  value       = vault_policy.opshub_api.name
}

output "opshub_api_vault_role" {
  description = "Vault Kubernetes authentication role for the OpsHub API"
  value       = vault_kubernetes_auth_backend_role.opshub_api.role_name
}