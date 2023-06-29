


output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "vpc id used by the cluster"
}

output "cluster_name" {
  value       = local.cluster_name
  description = "cluster name"
}

output "arn_autoscaler_role" {
  value       = aws_iam_role.cluster_autoscaler_role.arn
  description = "arn of the cluster autoscaler role"
}


# output "arn_ingress_role" {
#   value       = aws_iam_role.AmazonEKSLoadBalancerControllerRoleEC2.arn
#   description = "this is the arn for the role to be used in annotation to provide the role to the ingress"
# }


output "arn_for_pods" {
  value       = aws_iam_role.role_for_pod.arn
  description = "this is the arn for the role to be used in for pods to access AWS services"
}

