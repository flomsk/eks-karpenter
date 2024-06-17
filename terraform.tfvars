vpc_id = "vpc-01234567890abcdef"

kube = {
    enabled = true
    cluster_name = "test"
    cluster_version = "1.30"
    workers_config = {
      karpenter = {
        instance_types = ["m7g.medium"]
        desired_size = 2
        min_size = 2
        max_size = 2
      }
    }
}

karpenter = {
  namespace = "kube-system"
  chart_version = "0.37.0"
}