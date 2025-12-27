resource "random_string" "string" {
  length  = 8
  special = false
}

locals {
  cluster_name       = "mahin-eks-${random_string.string.result}"
  availability_zones = [for zone in data.aws_availability_zones.zones.names : zone if zone != "ap-south-1c"]
}