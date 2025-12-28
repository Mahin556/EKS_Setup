variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnets" {
  description = "Subnets CIDR"
  type        = list(string)
}

variable "public_subnets" {
  description = "Subnets CIDR"
  type        = list(string)
}

variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}