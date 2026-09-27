resource "helm_release" "vault_secrets_operator" {
  name      = "vault-secrets-operator"
  namespace = "vault-secrets-operator"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault-secrets-operator"
  version    = "1.6.0"

  create_namespace = true

  wait    = true
  atomic  = true
  timeout = 600

  values = [
    yamlencode({
      # ---------------------------------------------------
      # Controller
      # ---------------------------------------------------

      controller = {
        replicas = 2

        podDisruptionBudget = {
          enabled        = true
          maxUnavailable = 1
        }

        resources = {
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }

          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      # ---------------------------------------------------
      # Default Vault connection
      # ---------------------------------------------------

      defaultVaultConnection = {
        enabled = true

        address = "http://vault.vault.svc.cluster.local:8200"

        skipTLSVerify = true
      }

      # ---------------------------------------------------
      # Do NOT configure a default Vault auth method yet.
      #
      # We will create explicit VaultAuth resources later
      # for the application namespaces.
      # ---------------------------------------------------

      defaultAuthMethod = {
        enabled = false
      }

      # ---------------------------------------------------
      # CSI driver
      #
      # We are using VSO -> Kubernetes Secret synchronization,
      # not the VSO CSI driver.
      # ---------------------------------------------------

      csi = {
        enabled = false
      }
    })
  ]

  depends_on = [
    helm_release.vault
  ]
}