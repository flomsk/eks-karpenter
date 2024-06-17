variable "vpc_id" {
  type = string
}

variable "kube" {
  type = object({
    enabled                    = bool
    cluster_name               = string
    cluster_version            = string
    workers_config = object({
      karpenter = object({
        desired_size   = number
        min_size       = number
        max_size       = number
        instance_types = set(string)
      })
    })
  })
}

variable "karpenter" {
  type = object({
    namespace = string
    chart_version = string
  })
}