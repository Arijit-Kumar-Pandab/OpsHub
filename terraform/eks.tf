resource "aws_eks_cluster" "opshub" {
  name     = "${local.name_prefix}-eks"
  role_arn = aws_iam_role.eks_cluster.arn

  version = var.kubernetes_version

  # Use the modern EKS API-based authentication model.
  access_config {
    authentication_mode = "API"

    # The identity creating the cluster receives admin access.
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Control plane logging
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Keep both endpoints enabled initially.
  # Public access will be restricted using public_access_cidrs.
  vpc_config {
    subnet_ids = aws_subnet.private[*].id

    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.eks_cluster
  ]

  tags = {
    Name = "${local.name_prefix}-eks"
  }
}

resource "aws_eks_node_group" "system" {
  cluster_name = aws_eks_cluster.opshub.name

  node_group_name = "${local.name_prefix}-system"

  node_role_arn = aws_iam_role.eks_node.arn

  subnet_ids = aws_subnet.private[*].id

  ami_type = "AL2023_x86_64_STANDARD"

  capacity_type = "ON_DEMAND"

  instance_types = var.node_instance_types

  disk_size = 30

  scaling_config {
    min_size     = var.node_min_size
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role        = "system"
    project     = "opshub"
    environment = var.environment
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker_policy,
    aws_iam_role_policy_attachment.eks_node_ecr_policy,
    aws_iam_role_policy_attachment.eks_node_cni_policy
  ]

  tags = {
    Name = "${local.name_prefix}-system-node-group"
  }
}