/**
* this file define the data plane as EC2 instances
*
*/

// role for nodes
resource "aws_iam_role" "nodes_role" {
  name_prefix = local.cluster_name
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = local.default_tags
}


// assign managed policies
resource "aws_iam_role_policy_attachment" "nodes_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_role.name
}
resource "aws_iam_role_policy_attachment" "nodes_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_role.name
}
resource "aws_iam_role_policy_attachment" "nodes_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_role.name
}



// create nodes
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "default_group_for_${local.cluster_name}"
  node_role_arn   = aws_iam_role.nodes_role.arn
  subnet_ids      = module.vpc.public_subnets #[module.vpc.public_subnet_1, module.vpc.public_subnet_2]
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size

  # let's start by minimal setup - autoscaling should then adapt
  scaling_config {
    desired_size = 3
    max_size     = 20
    min_size     = 2
  }

  instance_types = [var.instance_types]

  # interesting to check the number of pods
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI

  depends_on = [
    aws_iam_role_policy_attachment.nodes_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_ec2_container_registry_read_only,
  ]


  tags = merge(
    local.default_tags,
    {
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"               = "TRUE"
  })
}

