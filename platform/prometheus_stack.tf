resource "helm_release" "kube_prometheus_stack" {
  name      = "kube-prometheus-stack"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "91.7.0"

  create_namespace = true

  wait    = true
  atomic  = true
  timeout = 900

  values = [
    yamlencode({
      # ---------------------------------------------------
      # CRDs
      # ---------------------------------------------------

      crds = {
        enabled = true
      }

      # ---------------------------------------------------
      # Prometheus Operator
      # ---------------------------------------------------

      prometheusOperator = {
        enabled = true

        resources = {
          requests = {
            cpu    = "50m"
            memory = "128Mi"
          }

          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      # ---------------------------------------------------
      # Prometheus
      # ---------------------------------------------------

      prometheus = {
        enabled = true

        prometheusSpec = {
          replicas = 1

          retention = "7d"

          scrapeInterval = "30s"

          evaluationInterval = "30s"

          resources = {
            requests = {
              cpu    = "300m"
              memory = "768Mi"
            }

            limits = {
              cpu    = "700m"
              memory = "1.5Gi"
            }
          }

          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp3"

                accessModes = [
                  "ReadWriteOnce"
                ]

                resources = {
                  requests = {
                    storage = "20Gi"
                  }
                }
              }
            }
          }

          # Discover ServiceMonitors and PodMonitors
          # across namespaces.
          serviceMonitorSelectorNilUsesHelmValues = false
          podMonitorSelectorNilUsesHelmValues     = false
        }
      }

      # ---------------------------------------------------
      # Alertmanager
      # ---------------------------------------------------

      alertmanager = {
        enabled = true

        alertmanagerSpec = {
          replicas = 1

          retention = "120h"

          resources = {
            requests = {
              cpu    = "50m"
              memory = "128Mi"
            }

            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp3"

                accessModes = [
                  "ReadWriteOnce"
                ]

                resources = {
                  requests = {
                    storage = "5Gi"
                  }
                }
              }
            }
          }
        }
      }

      # ---------------------------------------------------
      # Grafana
      # ---------------------------------------------------

      grafana = {
        enabled = true

        persistence = {
          enabled          = true
          type             = "pvc"
          storageClassName = "gp3"
          accessModes = [
            "ReadWriteOnce"
          ]
          size = "5Gi"
        }

        resources = {
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }

          limits = {
            cpu    = "300m"
            memory = "512Mi"
          }
        }

        service = {
          type = "ClusterIP"
        }

        # Current chart versions generate the admin
        # password when one is not explicitly supplied.
        admin = {
          user = "admin"
        }

        defaultDashboardsEnabled = true

        sidecar = {
          dashboards = {
            enabled = true
          }

          datasources = {
            enabled = true
          }
        }
      }

      # ---------------------------------------------------
      # kube-state-metrics
      # ---------------------------------------------------

      kubeStateMetrics = {
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
      # Node Exporter
      # ---------------------------------------------------

      nodeExporter = {
        enabled = true

        resources = {
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }

          limits = {
            cpu    = "200m"
            memory = "128Mi"
          }
        }
      }

      # ---------------------------------------------------
      # Default Kubernetes alerting rules
      # ---------------------------------------------------

      defaultRules = {
        create = true
      }

      # ---------------------------------------------------
      # Network policies
      # ---------------------------------------------------

      networkPolicy = {
        enabled = true
      }
    })
  ]

  depends_on = [
    kubernetes_storage_class_v1.gp3
  ]
}