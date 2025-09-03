# Environment Configuration - Cost Optimized
environment             = "dev"                # Environment name (dev/test/prod)
location                = "Central US"          # Cost-optimized region (15% cheaper than East US)
resource_group_name     = "aks-gitops-rg"      # Azure resource group name
kubernetes_cluster_name = "aks-gitops-cluster" # AKS cluster name
node_count              = 1                    # Reduced from 2 for cost savings
vm_size                 = "Standard_B2s"       # Cost-optimized VM (60% cheaper than D2s_v3)
kubernetes_version      = "1.32.5"             # Kubernetes version for AKS cluster

# GitOps Configuration
gitops_repo_url  = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git" # GitOps repository for infrastructure configs (reference only)
argocd_namespace = "argocd"                                          # Namespace where ArgoCD will be deployed

# Application Deployment Configuration 
app_repo_url  = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git" # Repository containing your application manifests
app_repo_path = "."                                                # Path within app repository containing Kubernetes manifests (root directory)

tags = {
  Environment = "development"
  Project     = "AKS-GitOps"
  ManagedBy   = "Terraform"
}

# Key Vault Configuration - Cost Optimized for Dev
enable_key_vault = false  # Disabled for dev environment to reduce costs
key_vault_sku    = "standard"

# Cost Optimization Settings
enable_spot_pool = true          # Enable spot instances for 60-90% savings
spot_max_price = 0.03           # Max $0.03/hour for spot instances
enable_scheduled_scaling = false # Disable scheduled scaling for dev
min_node_count = 1              # Minimum nodes in default pool
max_node_count = 3              # Maximum nodes in default pool
enable_ephemeral_disk = true    # Use ephemeral disks for cost savings

# Database Cost Optimization (Dev Environment)
enable_azure_database = false          # Keep container DB for maximum cost savings
database_sku_name = "B_Standard_B1ms"   # Burstable instance if enabled
database_storage_mb = 20480             # 20GB minimum storage
database_backup_retention_days = 7      # Minimum backup retention

# Database Credentials (will be stored in Key Vault)
postgres_username = "postgres"
postgres_password = "F@nEvent$2024!BkG"
postgres_database = "eventbookingdb"
