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

output "vpc_cni_role_arn" {
  description = "IAM role ARN used by the VPC CNI through EKS Pod Identity"
  value       = aws_iam_role.vpc_cni.arn
}

output "aws_load_balancer_controller_role_arn" {
  description = "IAM role ARN used by the AWS Load Balancer Controller"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "aws_load_balancer_controller_policy_arn" {
  description = "IAM policy ARN for the AWS Load Balancer Controller"
  value       = aws_iam_policy.aws_load_balancer_controller.arn
}

output "aws_load_balancer_controller_pod_identity_association_id" {
  description = "EKS Pod Identity association ID for the AWS Load Balancer Controller"
  value       = aws_eks_pod_identity_association.aws_load_balancer_controller.association_id
}

output "ebs_csi_role_arn" {
  description = "IAM role ARN used by the EBS CSI driver through EKS Pod Identity"
  value       = aws_iam_role.ebs_csi.arn
}

output "vault_kms_key_id" {
  description = "KMS key ID used for Vault auto-unseal"
  value       = aws_kms_key.vault.key_id
}

output "vault_kms_key_arn" {
  description = "KMS key ARN used for Vault auto-unseal"
  value       = aws_kms_key.vault.arn
}

output "vault_kms_role_arn" {
  description = "IAM role ARN used by Vault for AWS KMS auto-unseal"
  value       = aws_iam_role.vault_kms.arn
}