### Ref
- https://github.com/awslabs/amazon-eks-ami/releases

```bash
set AWS_PROFILE=tf-user2

aws s3api create-bucket --bucket mahin-raza-1312322 --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

terraform init

terraform plan 

terraform apply --auto-approve

aws eks update-kubeconfig --region ap-south-1 --name todo-app-eks
```