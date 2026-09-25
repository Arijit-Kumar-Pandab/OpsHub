output "vpc_id" {
  description = "ID of the OpsHub VPC"
  value       = aws_vpc.opshub.id
}

output "vpc_cidr" {
  description = "CIDR block of the OpsHub VPC"
  value       = aws_vpc.opshub.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "availability_zones" {
  description = "Availability Zones used by OpsHub"
  value       = data.aws_availability_zones.available.names
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.opshub.id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.opshub.name
}

output "eks_cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = aws_eks_cluster.opshub.endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version running on EKS"
  value       = aws_eks_cluster.opshub.version
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.opshub.arn
}

output "eks_node_group_name" {
  description = "EKS managed node group name"
  value       = aws_eks_node_group.system.node_group_name
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN used by EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
  value       = aws_iam_role.eks_node.arn
}

output "api_ecr_repository_url" {
  description = "ECR repository URL for the OpsHub API"
  value       = aws_ecr_repository.api.repository_url
}

output "worker_ecr_repository_url" {
  description = "ECR repository URL for the OpsHub worker"
  value       = aws_ecr_repository.worker.repository_url
}