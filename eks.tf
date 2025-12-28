module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  enable_irsa = true

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 2
      instance_types   = ["t2.small"]
      disk_size        = 20
      tags = {
        Name = "eks-node-group"
      }
    }
  }
   addons = {
    coredns                = {
      version        = "v1.13.0-eksbuild.1"
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
      version        = "v1.13.0-eksbuild.1"
    }
    kube-proxy             = {
      version        = "v1.26.7-eksbuild.1"
      before_compute = true
    }
    vpc-cni                = {
      version        = "v1.14.3-eksbuild.1"
      before_compute = true
    }
  }
  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
