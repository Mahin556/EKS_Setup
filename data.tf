data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_availability_zones" "zones" {
  state = "available"
}

data "aws_ami" "ami_id" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}