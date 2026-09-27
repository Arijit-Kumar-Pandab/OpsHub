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