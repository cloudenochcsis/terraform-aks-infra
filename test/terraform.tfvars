# Environment Configuration - Cost Optimized for Test
environment             = "test"               # Environment name (dev/test/prod)
location                = "Central US"          # Cost-optimized region
resource_group_name     = "aks-gitops-rg"      # Azure resource group name
kubernetes_cluster_name = "aks-gitops-cluster" # AKS cluster name
vm_size                 = "Standard_D2s_v3"    # Cost-optimized VM size
kubernetes_version      = "1.32.5"             # Kubernetes version for AKS cluster

# GitOps Configuration
gitops_repo_url  = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git" # GitOps repository for infrastructure configs (reference only)
argocd_namespace = "argocd"                                          # Namespace where ArgoCD will be deployed

# Application Deployment Configuration 
app_repo_url  = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git" # Repository containing your application manifests
app_repo_path = "."                                                # Path within app repository containing Kubernetes manifests (root directory)

tags = {
  Environment = "test"
  Project     = "AKS-GitOps"
  ManagedBy   = "Terraform"
}

# Key Vault Configuration
enable_key_vault = true
key_vault_sku    = "standard"

# Cost Optimization Settings for Test
enable_spot_pool = true          # Enable spot instances
spot_max_price = 0.05           # Max $0.05/hour for spot instances
enable_scheduled_scaling = true # Enable scheduled scaling for testing
min_node_count = 1              # Minimum nodes in default pool
max_node_count = 5              # Maximum nodes in default pool
enable_ephemeral_disk = false   # Keep managed disks for test stability

# Database Credentials (will be stored in Key Vault)
postgres_username = "postgres"
postgres_password = "SecurePassword123!"
postgres_database = "eventbookingdb"
