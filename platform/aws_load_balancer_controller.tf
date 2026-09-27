resource "helm_release" "aws_load_balancer_controller" {
  name      = "aws-load-balancer-controller"
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.14.0"

  create_namespace = false

  wait    = true
  atomic  = true
  timeout = 600

  values = [
    yamlencode({
      clusterName = var.cluster_name

      region = var.aws_region

      vpcId = data.aws_eks_cluster.opshub.vpc_config[0].vpc_id

      replicaCount = 2

      defaultTargetType = "ip"

      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
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
        maxUnavailable = 1
      }
    })
  ]

}