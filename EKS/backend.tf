terraform {
  backend "s3" {
    bucket       = "mahin-raza-1312322"
    region       = "ap-south-1"
    key          = "EKS-TF/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      version = ">= 6.0.0"
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}