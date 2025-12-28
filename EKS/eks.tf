module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.10.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  # Optional
  endpoint_public_access = true

  enable_irsa = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  authentication_mode = "API_AND_CONFIG_MAP"

  eks_managed_node_groups = {
    eks_nodes = {
      ami_type = "AL2023_x86_64_STANDARD"
      desired_size   = 2
      max_capacity   = 3
      min_capacity   = 2
      instance_types = ["t2.small"]
      disk_size      = 20
      tags = {
        Name = "eks-node-group"
      }
      vpc_security_group_ids = [aws_security_group.worker_management_sg.id]
    }
  }

  # # Truncated for brevity ...

  # access_entries = {
  #   # One access entry with a policy associated
  #   example = {
  #     principal_arn = "arn:aws:iam::123456789012:role/something"

  #     policy_associations = {
  #       example = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #         access_scope = {
  #           namespaces = ["default"]
  #           type       = "namespace"
  #         }
  #       }
  #     }
  #   }
  # }

  addons = {
    coredns = {
      most_recent_version = true
    }
    eks-pod-identity-agent = {
      before_compute = true
      most_recent_version = true
    }
    kube-proxy = {
      most_recent_version = true
    }
    vpc-cni = {
      most_recent_version = true
      before_compute = true
    }
  }
  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
