



resource "aws_iam_role" "role_for_pod" {
  name = "${local.cluster_name}-RoleForPods"
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
          # "Condition" : {
          #   "StringEquals" : {
          #     "${aws_iam_openid_connect_provider.cluster.url}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
          #   }
          # }
        }
      ]
    }
  )
  depends_on = [aws_iam_openid_connect_provider.cluster]
}


resource "aws_iam_policy" "policy_for_testing" {
  name        = "${local.cluster_name}Testing"
  description = ""

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_for_testing" {
  role       = aws_iam_role.role_for_pod.name
  policy_arn = aws_iam_policy.policy_for_testing.arn
}







# TO ACCESS SECRET MANAGER

# resource "aws_iam_policy" "secret_manager_access" {
#   name        = "${local.cluster_name}SecretManagerAccess"
#   description = ""

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "secretsmanager:GetSecretValue",
#                 "secretsmanager:DescribeSecret"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "secret_manager_access" {
#   role       = aws_iam_role.role_for_pod.name
#   policy_arn = aws_iam_policy.secret_manager_access.arn
# }



