resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" : "mahin-eks-vpc"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
    "kubernetes.io/role/elb" : "1"
    "Name" : "mahin-eks-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
    "kubernetes.io/role/internal-elb" : "1"
    "Name" : "mahin-eks-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" : "mahin-eks-igw"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id # MUST be PUBLIC subnet
  tags = {
    Name = "main-nat-gateway"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "myrt-public"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "myrt-private"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "rt-associate-1" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table_association" "rt-associate-2" {
  count          = length(aws_subnet.private_subnet)
  route_table_id = aws_route_table.private_subnet_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_security_group" "control_plane_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" : "mahin-eks-cluster-sg"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
}

resource "aws_security_group" "node_group_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" : "mahin-eks-node-group-sg"
    "kubernetes.io/cluster/${local.cluster_name}" : "shared"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" : "mahin-eks-ec2-sg"
  }
}