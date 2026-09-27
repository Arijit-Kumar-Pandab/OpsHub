resource "helm_release" "kyverno" {
  name      = "kyverno"
  namespace = "kyverno"

  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  version    = "3.9.0"

  create_namespace = true

  wait    = true
  atomic  = true
  timeout = 900

  values = [
    yamlencode({
      # ---------------------------------------------------
      # Admission Controller
      # ---------------------------------------------------

      admissionController = {
        replicas = 2

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
          maxUnavailable = 1
        }
      }

      # ---------------------------------------------------
      # Background Controller
      # ---------------------------------------------------

      backgroundController = {
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
      # Cleanup Controller
      # ---------------------------------------------------

      cleanupController = {
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
      # Reports Controller
      # ---------------------------------------------------

      reportsController = {
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
      # Metrics
      # ---------------------------------------------------

      metricsService = {
        create = true
      }
    })
  ]
}