# ---------------------------------------------------------
# AWS Load Balancer Controller IAM Policy
# ---------------------------------------------------------

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "${local.name_prefix}-aws-load-balancer-controller"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("${path.module}/policies/aws-load-balancer-controller.json")

  tags = {
    Name = "${local.name_prefix}-aws-load-balancer-controller"
  }
}


# ---------------------------------------------------------
# Trust Policy for EKS Pod Identity
# ---------------------------------------------------------

data "aws_iam_policy_document" "aws_load_balancer_controller_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}


# ---------------------------------------------------------
# IAM Role
# ---------------------------------------------------------

resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${local.name_prefix}-aws-load-balancer-controller-role"

  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_trust.json

  tags = {
    Name = "${local.name_prefix}-aws-load-balancer-controller-role"
  }
}


# ---------------------------------------------------------
# Attach Policy to Role
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}


# ---------------------------------------------------------
# EKS Pod Identity Association
# ---------------------------------------------------------

resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = aws_eks_cluster.opshub.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"

  role_arn = aws_iam_role.aws_load_balancer_controller.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.aws_load_balancer_controller
  ]

  tags = {
    Name = "${local.name_prefix}-aws-load-balancer-controller-association"
  }
}