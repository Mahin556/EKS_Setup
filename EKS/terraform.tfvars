vpc_cidr        = "192.168.0.0/16"
cluster_name    = "todo-app-eks"
kubernetes_version = "1.33"
private_subnets = [ "192.168.1.0/24", "192.168.2.0/24" ]
public_subnets = [ "192.168.3.0/24", "192.168.4.0/24" ]
profile = "tf-user"
region = "ap-south-1"