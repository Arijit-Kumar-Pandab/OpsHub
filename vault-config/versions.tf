terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "5.12.0"
    }
  }
}