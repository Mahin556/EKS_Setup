* https://github.com/eksctl-io/eksctl
* https://docs.aws.amazon.com/eks/latest/eksctl/installation.html

* https://devopscube.com/create-aws-eks-cluster-eksctl/
* https://subbaramireddyk.medium.com/amazon-eks-cluster-setup-using-eksctl-c582915a4e2f

* https://docs.aws.amazon.com/eks/latest/userguide/automode-get-started-eksctl.html
* https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
* https://docs.aws.amazon.com/eks/latest/eksctl/what-is-eksctl.html

---

**What is eksctl?**
• eksctl is a **command-line tool**
• Created by **Weaveworks**
• Simplifies EKS cluster creation
• Automates:
  * VPC
  * Subnets
  * Node groups
  * IAM roles
  * kubeconfig setup
Without eksctl:
• Manual console setup
• Very long and error-prone
With eksctl:
• One command = full cluster

---

```bash
# Prerequisites
aws --version
kubectl version --client
eksctl version

# Check which AWS identity you are using
aws sts get-caller-identity

# Check kubeconfig exists
ls -l ~/.kube/config

#Configure AWS credentials (one-time)
aws configure
# Provide:
# Access Key
# Secret Key
# Region (e.g. ap-south-1)
# Output format (json)
```

```bash
# Step 2: Create EKS cluster with managed node group (single command)
eksctl create cluster \
  --name demo-eks \
  --region ap-south-1 \
  --version 1.28 \
  --nodegroup-name demo-ng \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
  
# What eksctl does automatically
# - Creates VPC
# - Creates public & private subnets
# - Creates IAM roles
# - Creates control plane
# - Creates managed node group
# - Updates kubeconfig


# Step 3: Verify cluster and nodes
kubectl config get-contexts
kubectl get nodes
kubectl get pods -A


# Step 4: Check eksctl-managed resources
eksctl get cluster
eksctl get nodegroup --cluster demo-eks


# Step 5: (Optional) Create cluster using Fargate
eksctl create cluster \
  --name demo-eks-fargate \
  --region ap-south-1 \
  --fargate


# Step 6: (Optional) Deploy test workload
kubectl create deployment nginx --image=nginx
kubectl get pods


# Step 7: Delete cluster (cleanup)
eksctl delete cluster \
  --name demo-eks \
  --region ap-south-1
```

---

```bash
# Create EKS cluster (simple, default VPC)
eksctl create cluster \
  --name my-eks-cluster \
  --region ap-south-1
```

```bash
eksctl create cluster \
  --name cluster-one \
  --nodegroup-name nodegroup-one \
  --region us-east-1 \
  --node-type t2.micro \
  --nodes 2
```

```bash
# Create cluster with specific Kubernetes version
eksctl create cluster \
  --name my-eks-cluster \
  --region ap-south-1 \
  --version 1.29
```

```bash
eksctl create cluster \
  --name my-eks \
  --region ap-south-1 \
  --zones ap-south-1a,ap-south-1b
```

```bash
# Create cluster with managed node group
eksctl create cluster \
  --name my-eks-cluster \
  --region ap-south-1 \
  --nodegroup-name ng-1 \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
```

```bash
# Create cluster without nodes (control plane only)
eksctl create cluster \
  --name my-eks-cluster \
  --region ap-south-1 \
  --without-nodegroup
```

```bash
# Add node group later
eksctl create nodegroup \
  --cluster my-eks-cluster \
  --region ap-south-1 \
  --name ng-1 \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
```
```bash
eksctl create cluster \
  --name my-eks \
  --region ap-south-1 \
  --fargate
```

```bash
# Update kubeconfig for EKS (most important)
aws eks update-kubeconfig \
  --region <region> \
  --name <cluster-name>

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name my-eks-cluster
```


```bash
# Verify cluster access
kubectl get nodes
kubectl get pods -A

# Verify kubectl context
kubectl config get-contexts
kubectl config current-context


# (Old method) Check aws-auth ConfigMap
kubectl get configmap aws-auth -n kube-system


# EC2-specific fix (kubeconfig created as root)
sudo cp -r /root/.kube /home/ec2-user/
sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube
```

```bash
# List EKS clusters
eksctl get clusters
```

```bash
# List node groups
eksctl get nodegroup \
  --cluster my-eks-cluster \
  --region ap-south-1
```

```bash
# Describe cluster
eksctl utils describe-cluster \
  --name my-eks-cluster \
  --region ap-south-1
```

```bash
# Enable IAM OIDC provider (required for IRSA)
eksctl utils associate-iam-oidc-provider \
  --cluster my-eks-cluster \
  --region ap-south-1 \
  --approve
```

```bash
# Delete cluster (clean up)
eksctl delete cluster \
  --name my-eks-cluster \
  --region ap-south-1
```
