# EKS-KARPENTER

This repo contains a terraform code that allows you to bootstrap EKS cluster and Karpenter installation.

**_Some of the code is commented out because terraform cant have dependencies for resources that are not exist (for now). So please follow next steps._**

### Step-by-step

1. First we want to bootstrap the EKS cluster and karpenter nodegroup, to do so:
```
terraform init
terraform apply
```
After that we have EKS cluster running + Karpenter nodegroup where Karpenter controller workloadwill be located.
2. Uncomment code in `karpenter.tf` and `provider.tf`
3. Deploy Karpenter controller and create karpenter node pools doing again:
```
terraform init
terraform apply
```

After that we will be having Karpenter node pool for all the workload we want. 
Karpenter uses very good cost-effective algorithm to bootstrap required instance(s).

Also we can require specific architecture for our workload by using affinity/nodeSelector in k8s manifest files or helm values:
**`arm64`**
```
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: kubernetes.io/arch
                operator: In
                values:
                  - arm64
```
or
```
  nodeSelector:
    kubernetes.io/arch: 'arm64'
```

**`amd64`**
```
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: kubernetes.io/arch
                operator: In
                values:
                  - amd64
```
or
```
  nodeSelector:
    kubernetes.io/arch: 'amd64'
```