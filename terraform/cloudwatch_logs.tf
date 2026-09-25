resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${local.name_prefix}-eks/cluster"
  retention_in_days = 14

  tags = {
    Name = "${local.name_prefix}-eks-logs"
  }
}