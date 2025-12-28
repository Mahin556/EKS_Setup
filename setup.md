### EKS Setup using `eksctl`

```bash
eksctl create cluster --name Three-Tier-K8s-EKS-Cluster --region us-east-1 --node-type t2.medium --nodes-min 2 --nodes-max 2

aws eks update-kubeconfig --region ap-south-1 --name todo-app-eks

kubectl get nodes
```

---

### EKS Setup using terraform

```bash
terraform init
terrform validate
terraform plan --var-file=variables.tfvars
terraform apply --var-file=variables.tfvars
terraform apply -var vpc_id=$(aws ec2 describe-vpcs | jq -r .Vpcs[0].VpcId)
```

---

```bash
# Download IAM policy for AWS Load Balancer Controller
# This policy allows the controller to create and manage ALB/NLB, listeners, target groups, etc.
# Run this on your Jenkins server or admin machine:
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
```
```bash
# Create IAM policy in AWS
# This uploads the downloaded policy to AWS IAM
# The policy will later be attached to a Kubernetes service account
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
```
```bash
# Create / Associate OIDC Provider with EKS
# OIDC allows Kubernetes service accounts to assume IAM roles securely
# Without this, IRSA (IAM Roles for Service Accounts) will not work
eksctl utils associate-iam-oidc-provider \
  --region us-east-1 \
  --cluster Three-Tier-K8s-EKS-Cluster \
  --approve
```
```bash
# Create Kubernetes Service Account with IAM Role
# This creates:
#     IAM role
#     Attaches Load Balancer policy
#     Binds it to a Kubernetes service account
# The controller pods will use this role automatically
eksctl create iamserviceaccount \
  --cluster Three-Tier-K8s-EKS-Cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn arn:aws:iam::407622020962:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --region us-east-1
```
```bash
# Verify Load Balancer Controller is running
# After 1–2 minutes, check deployment status
kubectl get deployment -n kube-system aws-load-balancer-controller
# Pods should be in Running state
```
```bash
# Create namespace for application
# Application will run in a dedicated namespace
kubectl create namespace three-tier
```