


output "vpc_id" {
  value       = module.eks_cluster.vpc_id
  description = "vpc id"
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "arn_autoscaler_role" {
  value = module.eks_cluster.arn_autoscaler_role

}


# output "arn_ingress_role" {
#   value       = module.eks_cluster.arn_ingress_role
#   description = "this is the arn for the role to be used in annotation to provide the role to the ingress"

# }
output "arn_for_pods" {
  value       = module.eks_cluster.arn_for_pods
  description = ""

}


