**What is Amazon EKS?**
  • EKS stands for **Elastic Kubernetes Service**
  • It is AWS’s **managed Kubernetes service**
  • AWS manages the **control plane**, you manage the **worker nodes**

**Control plane includes:**
  • Kubernetes API Server
  • Scheduler
  • Controller Manager
  • etcd

**AWS responsibilities:**
  • Provision control plane
  • Maintain and patch master nodes
  • High availability of control plane
  • Scaling and backups

**Your responsibility:**
  • Worker nodes(in case of self managed nodes)
  • Application workloads


**Why use EKS (or any managed Kubernetes service)**
  Problems with self-managed Kubernetes:
  • Very complex to install
  • Hard to operate and scale
  • Requires deep Kubernetes expertise
  • Security and patching is manual

**Benefits of EKS:**
  • No control plane management
  • AWS handles security best practices
  • Highly available by default
  • Easy integration with AWS services:
    * IAM
    * Load Balancers
    * S3
    * Secrets Manager
      • Production-ready Kubernetes

**EKS Architecture (High-level)**
  • Control Plane → Managed by AWS
  • Worker Nodes → Managed by you (or partially by AWS)
  • Kubernetes API → Exposed securely
  • Applications run only on worker nodes

---

**Worker Node Options in EKS**

There are **3 ways** to run worker nodes.

**1. Self-managed worker nodes**
  **What it means:**
  • You create EC2 instances manually
  • You install Kubernetes components yourself
  **You must manage:**
  • kubelet
  • kube-proxy
  • container runtime
  • OS updates
  • Security patches
  • Node registration to cluster
  **Pros:**
  • Full control
  **Cons:**
  • High operational overhead
  • Not recommended for beginners

**2. Managed Node Groups (Most common)**
  **What AWS does:**
  • Creates EC2 instances for you
  • Uses EKS-optimized AMI
  • Manages lifecycle of nodes
  **What you control:**
  • Instance type
  • Min / max / desired capacity --> asg  ->auto scale based on the load
  • Scaling
  **Key points:**
  • Nodes are part of Auto Scaling Group
  • Easy upgrades and replacements
  • Balanced control + convenience
  **Recommended for:**
  • Most production workloads

**3. AWS Fargate (Serverless Kubernetes)**
  **What it means:**
  • No EC2 instances to manage
  • Pods run on-demand
  • AWS creates nodes automatically
  **Advantages:**
  • No server management
  • Pay only for what you use
  • Automatic scaling
  • Optimal instance selection
  **Disadvantages:**
  • Less control
  • Not suitable for all workloads
  **Best for:**
  • Microservices
  • Short-lived workloads
  • Teams that don’t want infra management

---

**Ways to create an EKS cluster**
  **1. AWS Console**
    • Manual
    • Time-consuming
    • Not scalable
  **2. eksctl**
    • Fast
    • Simple
    • Recommended for learning and POCs
  **3. Infrastructure as Code (Terraform / Pulumi)**
    • Best for production
    • Version controlled
    • Fully automated
