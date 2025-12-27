```bash
"kubernetes.io/cluster/${local.cluster_name}" = "shared"

WHAT THIS TAG IS
- A special AWS tag used by Kubernetes (EKS)
- Identifies which AWS resources belong to which EKS cluster
- Automatically discovered by EKS on VPCs, subnets, security groups, etc.
- This tag tells EKS which AWS resources belong to a specific Kubernetes cluster and
whether those resources are shared or owned by that cluster.

WHY KUBERNETES NEEDS IT
When EKS runs on AWS, it dynamically creates AWS resources:
- Load Balancers (ELB / ALB / NLB)
- ENIs (network interfaces)
- Security groups
- Route table entries

EKS must know:
“Which AWS resources it is allowed to use”
This tag is how EKS makes that decision.

BREAKDOWN OF THE TAG
kubernetes.io/cluster/<cluster-name>

- kubernetes.io        → Reserved Kubernetes namespace
- cluster/<cluster-name> → Identifies a specific EKS cluster
- ${local.cluster_name} → Terraform variable holding cluster name

Rendered example:
kubernetes.io/cluster/mahin-eks = shared

MEANING OF THE VALUE
Valid values:

shared
- Resource can be shared by multiple clusters
- Resource will NOT be deleted when the cluster is deleted
- Recommended for Terraform-managed infrastructure

owned
- Resource is fully owned by the cluster
- EKS may delete it automatically during cluster deletion
- Common with eksctl
- Risky if Terraform manages the resource

WHAT “shared” MEANS (MOST COMMON)
- VPC/subnet can be used by this EKS cluster
- Safe for shared or long-lived infrastructure
- Best practice with Terraform

WHAT “owned” MEANS
- Resource lifecycle tied to the cluster
- May be removed automatically by EKS
- Avoid for Terraform-managed VPCs

WHERE THIS TAG IS REQUIRED
- Subnets → MANDATORY
- VPCs → Recommended
- Security Groups → Sometimes required

Without this tag:
- LoadBalancer services fail
- Nodes may not join the cluster
- ALB/NLB provisioning breaks

REAL-WORLD SCENARIO
kubectl expose deployment nginx --type=LoadBalancer

EKS will:
- Search for subnets with this tag
- Select correct subnets
- Create ALB/NLB inside them

Missing tag → ❌ ERROR

WHY TAG THE VPC TOO
- Subnets must have it
- Tagging VPC improves:
  - Resource discovery
  - Clarity
  - Consistency
- Best practice for EKS + Terraform
```