# module "eks_karpenter" {
#   source  = "terraform-aws-modules/eks/aws//modules/karpenter"
#   version = "20.2.1"

#   cluster_name = module.eks[0].cluster_name

#   create_access_entry = true

#   create_iam_role      = true
#   create_node_iam_role = true

#   enable_irsa                     = true
#   irsa_oidc_provider_arn          = module.eks[0].oidc_provider_arn
#   irsa_namespace_service_accounts = ["kube-system:karpenter"]

#   enable_spot_termination = true

#   # Used to attach additional IAM policies to the Karpenter node IAM role
#   node_iam_role_additional_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }
# }

# resource "helm_release" "karpenter_crd" {
#   depends_on = [ module.eks_karpenter ]
#   name       = "karpenter-crd"
#   namespace  = var.karpenter.namespace
#   repository = "oci://public.ecr.aws/karpenter"
#   chart      = "karpenter-crd"
#   version    = var.karpenter.chart_version
# }

# resource "helm_release" "karpenter" {
#   depends_on = [ helm_release.karpenter_crd ]
#   name       = "karpenter"
#   namespace  = var.karpenter.namespace
#   repository = "oci://public.ecr.aws/karpenter"
#   chart      = "karpenter"
#   version    = var.karpenter.chart_version
#   values = [templatefile("${path.module}/templates/karpenter.tpl.yml", {
#     sa_role_arn    = module.eks_karpenter.iam_role_arn
#     cluster_name   = module.eks[0].cluster_name
#     queue_name     = module.eks_karpenter.queue_name
#   })]
# }

# module "karpenter_nodes" {
#   depends_on = [ helm_release.karpenter ]
#   source = "./modules/karpenter-nodes"

#   cluster_name                = module.eks[0].cluster_name
#   role_name                   = module.eks_karpenter.node_iam_role_name

# }
