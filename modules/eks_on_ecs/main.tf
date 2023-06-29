/**
* This file
* - create the cluster anche the permissions needed
* - define locals used in all the module
*/


locals {
  cluster_name = "c-eksec2--e-${var.environment}"
  default_tags = {
    env : var.environment
    eks_cluster_name : local.cluster_name
  }
}


resource "aws_eks_cluster" "cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.cluster_eks_role.arn
  # version                   = "1.20"
  enabled_cluster_log_types = []
  # enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids              = module.vpc.public_subnets #[module.vpc.public_subnet_1, module.vpc.public_subnet_2]
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  # IAM Role permissions have to be created before and deleted after EKS Cluster handling
  # otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_eks_cluster_policy,
    aws_iam_role_policy_attachment.cluster_eks_vpc_resource_controller,
  ]

  tags = local.default_tags
}




resource "aws_iam_role" "cluster_eks_role" {
  name_prefix = local.cluster_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_eks_role.name
}

# Optionally, enable Security Groups for Pods
# Reference:
# https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "cluster_eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_eks_role.name
}

