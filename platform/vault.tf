resource "helm_release" "vault" {
  name       = "vault"
  namespace  = "vault"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.34.1"

  create_namespace = true

  wait    = true
  atomic  = true
  timeout = 900

  values = [
    yamlencode({
      global = {
        enabled = true

        tlsDisable = true
      }

      # ---------------------------------------------------
      # Vault Server
      # ---------------------------------------------------

      server = {
        enabled = true

        replicas = 3

        updateStrategyType = "RollingUpdate"

        # Keep Vault internal to the cluster for now.
        service = {
          enabled = true

          type = "ClusterIP"
        }

        # -------------------------------------------------
        # Persistent storage
        # -------------------------------------------------

        dataStorage = {
          enabled      = true
          size         = "10Gi"
          storageClass = "gp3"

          accessMode = "ReadWriteOnce"
        }

        # -------------------------------------------------
        # HA + Integrated Raft Storage
        # -------------------------------------------------

        ha = {
          enabled = true

          replicas = 3

          raft = {
            enabled = true

            setNodeId = true

            config = <<-EOT
              ui = true

              cluster_name = "opshub-vault"

              storage "raft" {
                path = "/vault/data/"
              }

              listener "tcp" {
                address         = "[::]:8200"
                cluster_address = "[::]:8201"
                tls_disable     = "true"
              }

              service_registration "kubernetes" {}
            EOT
          }
        }

        # -------------------------------------------------
        # Resource management
        # -------------------------------------------------

        resources = {
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }

          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }

        # -------------------------------------------------
        # Spread Vault replicas across nodes where possible
        # -------------------------------------------------

        affinity = {
          podAntiAffinity = {
            preferredDuringSchedulingIgnoredDuringExecution = [
              {
                weight = 100

                podAffinityTerm = {
                  topologyKey = "kubernetes.io/hostname"

                  labelSelector = {
                    matchLabels = {
                      "app.kubernetes.io/name" = "vault"
                    }
                  }
                }
              }
            ]
          }
        }

        # -------------------------------------------------
        # PDB
        # -------------------------------------------------

        disruptionBudget = {
          maxUnavailable = 1
        }

        # -------------------------------------------------
        # Vault Agent Injector
        #
        # We will use Vault Secrets Operator instead.
        # -------------------------------------------------

        injector = {
          enabled = false
        }
      }

      # ---------------------------------------------------
      # Vault Agent Injector
      # ---------------------------------------------------

      injector = {
        enabled = false
      }

      # ---------------------------------------------------
      # Vault UI
      # ---------------------------------------------------

      ui = {
        enabled = true
      }
    })
  ]
}