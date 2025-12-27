output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "node_group_id" {
  value = aws_iam_role.eks_node_group_role.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "eks_connect" {
  value = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name}"
}