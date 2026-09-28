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

# ---------------------------------------------------------
# Vault KMS Pod Identity Role
# ---------------------------------------------------------

data "aws_iam_policy_document" "vault_kms_pod_identity_trust" {
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

resource "aws_iam_role" "vault_kms" {
  name = "${local.name_prefix}-vault-kms-role"

  assume_role_policy = data.aws_iam_policy_document.vault_kms_pod_identity_trust.json

  tags = {
    Name = "${local.name_prefix}-vault-kms-role"
  }
}

data "aws_iam_policy_document" "vault_kms" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.vault.arn
    ]
  }
}

resource "aws_iam_role_policy" "vault_kms" {
  name   = "${local.name_prefix}-vault-kms-policy"
  role   = aws_iam_role.vault_kms.id
  policy = data.aws_iam_policy_document.vault_kms.json
}

resource "aws_eks_pod_identity_association" "vault_kms" {
  cluster_name    = aws_eks_cluster.opshub.name
  namespace       = "vault"
  service_account = "vault"

  role_arn = aws_iam_role.vault_kms.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy.vault_kms
  ]

  tags = {
    Name = "${local.name_prefix}-vault-kms-association"
  }
}