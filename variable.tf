variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "vpc_cidr" {
  type        = string
  description = "Default CIDR range of the VPC"
}

variable "aws_profile" {
  type        = string
  description = "Profile used to create resources in AWS"
}

variable "public_subnet" {
  type = list(string)
}

variable "private_subnet" {
  type = list(string)
}

variable "ssh_key_name" {
  type = string
}