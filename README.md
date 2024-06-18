# EKS-KARPENTER

This repo contains a terraform code that allows you to bootstrap EKS cluster and Karpenter installation.

**_Some of the code is commented out because terraform cant have dependencies for resources/providers that are not exist (in the moment of apply). So please follow next steps._**

### Step-by-step

1. First we want to bootstrap the EKS cluster and karpenter nodegroup, where Karpenter controller workload will be located. To do so:
```
terraform init
terraform apply
```

2. Uncomment code in `karpenter.tf` and `provider.tf`

3. Deploy Karpenter controller helm chart and create karpenter node pools doing again:
```
terraform init
terraform apply
```

After that we will be having Karpenter node pool for all the workload we would need. 

Karpenter uses very good cost-effective algorithm to bootstrap required instance(s).

### Deployment architecture choose
We can require specific architecture for our workload by using affinity/nodeSelector in k8s manifest files or helm values:

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
