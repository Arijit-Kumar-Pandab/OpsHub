variable "aws_region" {
  description = "AWS region where the EKS cluster is running"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "opshub-dev-eks"
}

variable "vault_kms_key_id" {
  description = "AWS KMS key ID used by Vault for auto-unseal"
  type        = string
}