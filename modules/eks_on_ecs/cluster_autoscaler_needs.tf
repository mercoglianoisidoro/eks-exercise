/*
* Creation of policy and role needed by the cluster autoscaler
* for more info https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html
*
*/



resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "${local.cluster_name}-AutoscalerPolicy"
  description = ""
  tags        = local.default_tags

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeImages",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "eks:DescribeNodegroup"
      ],
      "Resource": ["*"]
    }
  ]
}

EOF
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_policy" {
  role       = aws_iam_role.cluster_autoscaler_role.name
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
}


resource "aws_iam_role" "cluster_autoscaler_role" {
  name = "${local.cluster_name}-AmazonEKSClusterAutoscalerRoleEC2"
  tags = local.default_tags
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : aws_iam_openid_connect_provider.cluster.arn,

          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          #TODO
          "Condition" : {
            "StringEquals" : {
              "${aws_iam_openid_connect_provider.cluster.url}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
            }
          }
        }
      ]
    }
  )

}
# "Federated" : replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")
