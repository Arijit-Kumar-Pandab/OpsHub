# ---------------------------------------------------------
# IAM Role for VPC CNI
# ---------------------------------------------------------

data "aws_iam_policy_document" "vpc_cni_pod_identity_trust" {
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

resource "aws_iam_role" "vpc_cni" {
  name = "${local.name_prefix}-vpc-cni-role"

  assume_role_policy = data.aws_iam_policy_document.vpc_cni_pod_identity_trust.json

  tags = {
    Name = "${local.name_prefix}-vpc-cni-role"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ---------------------------------------------------------
# EBS CSI Driver IAM Role
# ---------------------------------------------------------

data "aws_iam_policy_document" "ebs_csi_pod_identity_trust" {
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

resource "aws_iam_role" "ebs_csi" {
  name = "${local.name_prefix}-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_pod_identity_trust.json

  tags = {
    Name = "${local.name_prefix}-ebs-csi-role"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicyV2"
}