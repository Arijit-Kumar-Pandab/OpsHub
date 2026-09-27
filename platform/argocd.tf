resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.9.2"

  create_namespace = true

  wait    = true
  atomic  = true
  timeout = 900

  values = [
    yamlencode({
      global = {
        networkPolicy = {
          create = true
        }
      }

      # ---------------------------------------------------
      # Argo CD Controller
      # ---------------------------------------------------

      controller = {
        replicas = 1

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
      }

      # ---------------------------------------------------
      # Argo CD Server
      # ---------------------------------------------------

      server = {
        replicas = 1

        service = {
          type = "ClusterIP"
        }

        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }

          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }

        podDisruptionBudget = {
          enabled        = true
          minAvailable   = 0
          maxUnavailable = 1
        }
      }

      # ---------------------------------------------------
      # Argo CD Repo Server
      # ---------------------------------------------------

      repoServer = {
        replicas = 1

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
      }

      # ---------------------------------------------------
      # ApplicationSet Controller
      # ---------------------------------------------------

      applicationSet = {
        replicas = 1

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
      # Redis
      # ---------------------------------------------------

      redis = {
        enabled = true

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
      # Disable Dex for now
      # Local Argo CD authentication will be used initially.
      # ---------------------------------------------------

      dex = {
        enabled = false
      }

      # ---------------------------------------------------
      # Disable HA Redis
      # HA Redis requires at least 3 worker nodes.
      # Our current dev cluster uses 2 desired nodes.
      # ---------------------------------------------------

      redis-ha = {
        enabled = false
      }
    })
  ]
}