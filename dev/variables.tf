variable "environment" {
  description = "Environment name, such as 'prod', 'staging', 'dev'"
  type        = string
  default     = "dev"
}
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "aks-gitops-rg"
}

variable "kubernetes_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-gitops-cluster"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.5"
}

variable "gitops_repo_url" {
  description = "GitOps repository URL for ArgoCD"
  type        = string
  default     = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git"
}

variable "argocd_namespace" {
  description = "Namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "app_repo_url" {
  description = "Repository URL for the application to be deployed via ArgoCD"
  type        = string
  default     = "https://github.com/cloudenochcsis/gitops-k8s-manifests.git"
}

variable "app_repo_path" {
  description = "Path within the repository for the application manifests"
  type        = string
  default     = "."
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "AKS-GitOps"
    ManagedBy   = "Terraform"
  }
}

# Key Vault Configuration
variable "enable_key_vault" {
  description = "Enable Key Vault for secrets management"
  type        = bool
  default     = true
}

variable "key_vault_sku" {
  description = "Key Vault SKU"
  type        = string
  default     = "standard"
}

# External Secrets Configuration
# External Secrets Configuration (using null_resource approach)
# variable "enable_external_secrets" {
#   description = "Enable External Secrets Operator for dynamic secret management"
#   type        = bool
#   default     = false
# }
# Note: External Secrets Operator is now deployed via null_resource to avoid chicken-egg problem

# Database Configuration
variable "postgres_username" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
  default     = "SecurePassword123!"
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
  default     = "goalsdb"
}

# Cost optimization variables
variable "enable_spot_pool" {
  description = "Enable spot instance node pool for cost savings"
  type        = bool
  default     = true
}

variable "spot_max_price" {
  description = "Maximum price per hour for spot instances in USD"
  type        = number
  default     = 0.05
}

variable "enable_scheduled_scaling" {
  description = "Enable scheduled scaling for off-hours cost savings"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes in default pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in default pool"
  type        = number
  default     = 3
}

variable "enable_ephemeral_disk" {
  description = "Use ephemeral OS disks for cost savings"
  type        = bool
  default     = false
}

# Database provisioning options
variable "enable_azure_database" {
  description = "Enable Azure Database for PostgreSQL (vs container database)"
  type        = bool
  default     = false  # Keep container database by default for cost savings
}

variable "database_sku_name" {
  description = "Database SKU name for cost optimization"
  type        = string
  default     = "B_Standard_B1ms"  # Burstable, cost-optimized
}

variable "database_storage_mb" {
  description = "Database storage in MB"
  type        = number
  default     = 20480  # 20GB minimum for cost optimization
}

variable "database_backup_retention_days" {
  description = "Database backup retention days"
  type        = number
  default     = 7  # Minimum for cost savings
}
