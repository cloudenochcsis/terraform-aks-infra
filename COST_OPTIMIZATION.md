# AKS Infrastructure Cost Optimization Guide

This document outlines the cost optimization changes implemented in the `cost-optimization` branch.

## 🎯 Optimization Goals

- **Target**: 70-85% reduction in monthly infrastructure costs
- **Focus**: Maintain functionality while significantly reducing Azure spending
- **Approach**: Smart resource sizing, spot instances, and efficient auto-scaling

## 💰 Cost Optimization Changes

### 1. **VM Size Optimization**
- **Dev Environment**: `Standard_D2s_v3` → `Standard_B2s` (60% cost reduction)
- **Test Environment**: `Standard_D4s_v3` → `Standard_D2s_v3` (50% cost reduction)  
- **Prod Environment**: `Standard_D8s_v3` → `Standard_D4s_v3` (50% cost reduction)

### 2. **Regional Optimization**
- **All Environments**: `East US` → `Central US` (15% cost reduction)

### 3. **Spot Instance Implementation**
- **New Feature**: Added spot node pools with 60-90% cost savings
- **Configuration**: Auto-scaling from 0-10 nodes based on demand
- **Targeting**: Non-critical workloads only (protected by taints)

### 4. **Enhanced Auto-scaling**
- **Policy**: `least-waste` expander for cost-focused scaling decisions
- **Thresholds**: Lower utilization thresholds (0.3) for faster scale-down
- **Timing**: Faster scale-down detection (5 minutes vs default 10 minutes)

### 5. **Operating System Optimization**
- **All Environments**: Ubuntu → Azure Linux (no licensing costs)
- **Dev Environment**: Ephemeral disks enabled for additional cost savings

### 6. **Key Vault Optimization**
- **Dev Environment**: Key Vault disabled (use ConfigMaps/Secrets instead)
- **Test/Prod**: Key Vault retained for security requirements

## 📊 Cost Impact Analysis

| Component | Before | After | Savings |
|-----------|--------|-------|---------|
| Dev VM Size | D2s_v3 | B2s | 60% |
| Test VM Size | D4s_v3 | D2s_v3 | 50% |
| Prod VM Size | D8s_v3 | D4s_v3 | 50% |
| Regional | East US | Central US | 15% |
| Spot Workloads | N/A | Spot pricing | 60-90% |
| OS Licensing | Ubuntu | Azure Linux | 100% |
| **Total Estimated** | **100%** | **15-30%** | **70-85%** |

## 🚀 New Features Added

### Spot Instance Node Pool
- **Purpose**: Handle burst workloads and non-critical applications
- **Scaling**: 0-10 nodes based on demand
- **Cost**: Up to 90% cheaper than regular instances
- **Protection**: Taints prevent critical workloads from scheduling

### Scheduled Node Pool (Optional)
- **Purpose**: Handle predictable off-hours workloads
- **Scaling**: 0-5 nodes, can scale to zero during downtime
- **VM Type**: Burstable instances (B2s) for variable workloads

### Cost-Optimized Auto-scaler
- **Strategy**: `least-waste` for cost-focused decisions
- **Speed**: 30-second scan intervals for quick adjustments
- **Efficiency**: Lower utilization thresholds for better resource usage

## 🔧 New Configuration Variables

```hcl
# Cost optimization controls
enable_spot_pool         = true    # Enable spot instances
spot_max_price          = 0.05    # Max hourly cost for spots
enable_scheduled_scaling = false   # Enable scheduled node pool
min_node_count          = 1       # Minimum default nodes
max_node_count          = 3       # Maximum default nodes
enable_ephemeral_disk   = true    # Use ephemeral storage
```

## 📝 Environment-Specific Settings

### Development
- **VM Size**: B2s (burstable, cost-optimized)
- **Key Vault**: Disabled to reduce costs
- **Spot Instances**: Enabled ($0.03/hour max)
- **Ephemeral Disks**: Enabled for maximum savings
- **Scaling**: 1-3 nodes

### Test
- **VM Size**: D2s_v3 (standard performance)
- **Key Vault**: Enabled for testing
- **Spot Instances**: Enabled ($0.05/hour max)
- **Scheduled Scaling**: Enabled for testing
- **Scaling**: 1-5 nodes

### Production
- **VM Size**: D4s_v3 (balanced performance/cost)
- **Key Vault**: Enabled for security
- **Spot Instances**: Enabled ($0.08/hour max, reliability focus)
- **Managed Disks**: Retained for stability
- **Scaling**: 2-10 nodes (higher reliability)

## 🛡️ Workload Targeting

### Regular Workloads
- **Target**: Default node pool with regular pricing
- **Use Case**: Critical applications, system services
- **Reliability**: High availability, predictable performance

### Spot Workloads
- **Target**: Spot node pool with significant cost savings
- **Use Case**: Batch jobs, CI/CD, development workloads
- **Constraint**: Must tolerate interruptions
- **Taint**: `kubernetes.azure.com/scalesetpriority=spot:NoSchedule`

### Example Workload Targeting
```yaml
# For spot-tolerant workloads
spec:
  tolerations:
  - key: "kubernetes.azure.com/scalesetpriority"
    operator: "Equal"
    value: "spot"
    effect: "NoSchedule"
  nodeSelector:
    kubernetes.azure.com/scalesetpriority: spot
```

## 🚦 Deployment Instructions

1. **Review Configuration**: Check terraform.tfvars for your environment
2. **Plan Changes**: Run `terraform plan` to review resource changes
3. **Apply Changes**: Deploy with `terraform apply`
4. **Monitor Costs**: Use Azure Cost Management to track savings

## 🔍 Monitoring & Validation

### Cost Monitoring
- **Azure Cost Management**: Track daily spending changes
- **Resource Usage**: Monitor CPU/memory utilization
- **Spot Instance Health**: Watch for eviction patterns

### Performance Validation  
- **Application Response Times**: Ensure no performance degradation
- **Auto-scaling Behavior**: Verify scaling responds appropriately to load
- **Spot Instance Workloads**: Confirm fault tolerance

## ⚠️ Important Notes

1. **Spot Instance Limitations**: Not suitable for critical, always-on workloads
2. **Ephemeral Disks**: Data is lost when nodes are deallocated
3. **Regional Considerations**: Ensure all dependent services support Central US
4. **Performance Testing**: Validate application performance with new VM sizes

## 🔄 Rollback Plan

If issues arise:
1. **Quick Fix**: Disable spot instances by setting `enable_spot_pool = false`
2. **VM Size Revert**: Increase VM sizes in terraform.tfvars if performance issues
3. **Regional Revert**: Change region back to `eastus` if needed
4. **Full Rollback**: Merge main branch to revert all changes

## 📈 Next Steps

1. **Deploy to Dev**: Test cost optimizations in development first
2. **Monitor for 1 week**: Validate cost savings and performance
3. **Deploy to Test**: Apply to test environment with validation
4. **Production Deployment**: Final deployment with careful monitoring

---

**💡 Remember**: Cost optimization is an ongoing process. Regularly review and adjust based on actual usage patterns and Azure pricing changes.
