# Environment Configuration - Cost Optimized for Production
environment             = "prod"               # Environment name (dev/test/prod)
location                = "Central US"          # Cost-optimized region (15% cheaper)
resource_group_name     = "aks-gitops-rg"      # Azure resource group name
kubernetes_cluster_name = "aks-gitops-cluster" # AKS cluster name
vm_size                 = "Standard_D4s_v3"    # Reduced from D8s_v3 for cost savings (50% cheaper)
kubernetes_version      = "1.32.5"             # Kubernetes version for AKS cluster

# GitOps Configuration
gitops_repo_url  = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git" # GitOps repository for infrastructure configs (reference only)
argocd_namespace = "argocd"                                          # Namespace where ArgoCD will be deployed

# Application Deployment Configuration 
app_repo_url  = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git" # Repository containing your application manifests
app_repo_path = "."                                                # Path within app repository containing Kubernetes manifests (root directory)

tags = {
  Environment = "production"
  Project     = "AKS-GitOps"
  ManagedBy   = "Terraform"
}

# Key Vault Configuration
enable_key_vault = true
key_vault_sku    = "standard"

# Cost Optimization Settings for Production
enable_spot_pool = true          # Enable spot instances for non-critical workloads
spot_max_price = 0.08           # Higher limit for production reliability
enable_scheduled_scaling = false # Disable for production (24/7 availability)
min_node_count = 2              # Higher minimum for production reliability
max_node_count = 10             # Higher maximum for production scaling
enable_ephemeral_disk = false   # Keep managed disks for production stability

# Database Credentials (will be stored in Key Vault)
postgres_username = "postgres"
postgres_password = "SecurePassword123!"
postgres_database = "eventbookingdb"
