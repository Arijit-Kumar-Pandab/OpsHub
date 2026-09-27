resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.14.0"

  create_namespace = false

  wait    = true
  atomic  = true
  timeout = 600

  values = [
    yamlencode({
      # ---------------------------------------------------
      # High Availability
      # ---------------------------------------------------

      replicas = 2

      podDisruptionBudget = {
        enabled        = true
        maxUnavailable = 1
      }

      # ---------------------------------------------------
      # Resource management
      # ---------------------------------------------------

      resources = {
        requests = {
          cpu    = "50m"
          memory = "100Mi"
        }

        limits = {
          cpu    = "200m"
          memory = "256Mi"
        }
      }

      # ---------------------------------------------------
      # Kubernetes API / Kubelet connectivity
      # ---------------------------------------------------

      apiService = {
        create = true
      }

      defaultArgs = [
        "--cert-dir=/tmp",
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s"
      ]

      # ---------------------------------------------------
      # Spread replicas across worker nodes
      # ---------------------------------------------------

      affinity = {
        podAntiAffinity = {
          preferredDuringSchedulingIgnoredDuringExecution = [
            {
              weight = 100

              podAffinityTerm = {
                topologyKey = "kubernetes.io/hostname"

                labelSelector = {
                  matchLabels = {
                    "app.kubernetes.io/name" = "metrics-server"
                  }
                }
              }
            }
          ]
        }
      }

      # ---------------------------------------------------
      # Security
      # ---------------------------------------------------

      securityContext = {
        allowPrivilegeEscalation = false
        readOnlyRootFilesystem   = true
        runAsNonRoot             = true
        runAsUser                = 1000

        seccompProfile = {
          type = "RuntimeDefault"
        }

        capabilities = {
          drop = [
            "ALL"
          ]
        }
      }

      # ---------------------------------------------------
      # Keep Metrics Server internal
      # ---------------------------------------------------

      service = {
        type = "ClusterIP"
      }

      # ---------------------------------------------------
      # Don't expose /metrics publicly
      # ---------------------------------------------------

      metrics = {
        enabled = false
      }
    })
  ]

}