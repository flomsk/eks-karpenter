provider "aws" {
  region  = "us-east-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# data "aws_eks_cluster" "cluster" {
#   count = var.kube.enabled ? 1 : 0
#   name = module.eks[0].cluster_name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   count = var.kube.enabled ? 1 : 0
#   name = module.eks[0].cluster_name
# }

# provider "kubernetes" {
#   host                   = length(data.aws_eks_cluster.cluster) != 0 ? data.aws_eks_cluster.cluster[0].endpoint : "https://null"
#   cluster_ca_certificate = length(data.aws_eks_cluster.cluster) != 0 ? base64decode(data.aws_eks_cluster.cluster[0].certificate_authority.0.data) : "null"
# #   token                  = length(data.aws_eks_cluster_auth.cluster) != 0 ? data.aws_eks_cluster_auth.cluster[0].token : "null"
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
#     command     = "aws"
#   }
# }

# provider "kubectl" {
#   host                   = length(data.aws_eks_cluster.cluster) != 0 ? data.aws_eks_cluster.cluster[0].endpoint : "https://null"
#   cluster_ca_certificate = length(data.aws_eks_cluster.cluster) != 0 ? base64decode(data.aws_eks_cluster.cluster[0].certificate_authority.0.data) : "null"
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", module.eks[0].cluster_name]
#     command     = "aws"
#   }
# }

# provider "helm" {
#   kubernetes {
#   host                   = length(data.aws_eks_cluster.cluster) != 0 ? data.aws_eks_cluster.cluster[0].endpoint : "https://null"
#   cluster_ca_certificate = length(data.aws_eks_cluster.cluster) != 0 ? base64decode(data.aws_eks_cluster.cluster[0].certificate_authority.0.data) : "null"
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks[0].cluster_name]
#       command     = "aws"
#     }
#   }
# }
