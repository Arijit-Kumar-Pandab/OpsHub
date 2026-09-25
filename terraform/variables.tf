variable "aws_region" {
  description = "AWS region where OpsHub infrastructure will be deployed"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "opshub"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the OpsHub VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zone_count" {
  description = "Number of Availability Zones"
  type        = number
  default     = 2
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "opshub-dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.36"
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_disk_size" {
  description = "Root disk size for EKS worker nodes in GiB"
  type        = number
  default     = 30
}

variable "cluster_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public EKS API endpoint"
  type        = list(string)

  # Development default only.
  # Replace with your public IP/32 before terraform apply.
  default = ["0.0.0.0/0"]
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR ranges allowed to access the public EKS Kubernetes API endpoint"
  type        = list(string)

  # Temporary default for planning.
  # Before terraform apply, replace this with your public IP/32.
  default = ["0.0.0.0/0"]
}
