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

variable "vault_addr" {
  description = "Address used by Terraform to connect to Vault"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "opshub_namespace" {
  description = "Kubernetes namespace used by the OpsHub application"
  type        = string
  default     = "opshub"
}

variable "opshub_api_service_account" {
  description = "Kubernetes service account used by the OpsHub API"
  type        = string
  default     = "opshub-api"
}