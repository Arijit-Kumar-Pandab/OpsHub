data "aws_eks_cluster" "opshub" {
  name = var.cluster_name
}