aws_region         = "ap-south-1"
kubernetes_version = "1.33"
vpc_cidr           = "10.0.0.0/16"
aws_profile        = "tf-user2"
public_subnet      = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet     = ["10.0.3.0/24", "10.0.4.0/24"]
ssh_key_name       = "ssh-key2"