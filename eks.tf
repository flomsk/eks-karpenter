module "eks" {
  count = var.kube.enabled ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.kube.cluster_name
  cluster_version = var.kube.cluster_version
  subnet_ids      = [aws_subnet.primary.id, aws_subnet.secondary.id]
  vpc_id          = var.vpc_id

  # IPV4
  cluster_ip_family = "ipv4"
  enable_irsa = true
  authentication_mode = "API"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  cluster_endpoint_private_access      = true

  cluster_tags = {
    "karpenter.sh/discovery" = "${var.kube.cluster_name}"
  }

  cluster_security_group_tags = {
    "karpenter.sh/discovery" = "${var.kube.cluster_name}"
  }

  # Disable control plane logs saving
  cluster_enabled_log_types   = []
  create_cloudwatch_log_group = false

  #Disable encryption
  create_kms_key                   = false
  cluster_encryption_config        = {}
  attach_cluster_encryption_policy = false

  # Extend node-to-node security group rules
  node_security_group_enable_recommended_rules = true

  # Avoid tagging two security groups with same tag
  node_security_group_tags = {
    "karpenter.sh/discovery" = "${var.kube.cluster_name}"
  }

  cluster_timeouts = {
    create = "50m"
    update = "50m"
    delete = "50m"
  }

  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy            = false
    enable_monitoring                     = true
    ebs_optimized                         = true
    use_name_prefix                       = true
    attach_cluster_primary_security_group = true
    create_launch_template                = true
    launch_template_name                  = ""
    create_security_group                 = false
    update_config = {
      max_unavailable = 1
    }
    timeouts = {
      create = "50m"
      update = "50m"
      delete = "50m"
    }
  }

  eks_managed_node_groups = {
    karpenter = {
      name           = "karpenter"
      ami_type       = "AL2023_ARM_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      desired_size   = var.kube.workers_config.karpenter.desired_size
      min_size       = var.kube.workers_config.karpenter.min_size
      max_size       = var.kube.workers_config.karpenter.max_size
      instance_types = var.kube.workers_config.karpenter.instance_types
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
      labels = {
        group = "karpenter"
      }
      taints = {
        group = {
          key    = "group"
          value  = "karpenter"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  # If you want to maintain the current default behavior of v19.x
  kms_key_enable_default_policy = false

}