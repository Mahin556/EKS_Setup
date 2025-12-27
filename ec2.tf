resource "aws_iam_role" "ec2_eks_role" {
  name = "ec2-eks-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.ec2_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-eks-profile"
  role = aws_iam_role.ec2_eks_role.name
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.ec2_eks_role.arn}
  username: ec2-admin
  groups:
    - system:masters
EOF
  }
}

resource "aws_instance" "eks_admin_ec2" {
  depends_on             = [kubernetes_config_map.aws_auth, aws_eks_cluster.eks_cluster]
  ami                    = "ami-0c44f651ab5e9285f"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = aws_subnet.public_subnet[0].id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "eks-admin-ec2"
  }
  user_data = <<EOF
#!/bin/bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.30.0/2024-05-11/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.eks_cluster.name}
kubectl get nodes
EOF
}


