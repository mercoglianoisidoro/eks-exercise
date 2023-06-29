


/**
* Create log groups to be used by cloud watch agent
*/
# todo: retention period

resource "aws_cloudwatch_log_group" "log_group_dataplane-log-grp" {
  name              = "/aws/containerinsights/${local.cluster_name}/dataplane-log-grp"
  tags              = local.default_tags
  retention_in_days = 1
}
resource "aws_cloudwatch_log_group" "log_group_dataplane" {
  name              = "/aws/containerinsights/${local.cluster_name}/dataplane"
  tags              = local.default_tags
  retention_in_days = 1
}
resource "aws_cloudwatch_log_group" "log_group_application" {
  name              = "/aws/containerinsights/${local.cluster_name}/application"
  tags              = local.default_tags
  retention_in_days = 1
}
resource "aws_cloudwatch_log_group" "log_group_performance" {
  name              = "/aws/containerinsights/${local.cluster_name}/performance"
  tags              = local.default_tags
  retention_in_days = 1
}



resource "aws_iam_policy" "grant_logs_policy" {
  name        = "${local.cluster_name}-LogPolicy"
  description = ""
  tags        = local.default_tags
  policy      = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "none",
			"Effect": "Allow",
			"Action": [
                "applicationinsights:*",
				"cloudwatch:*"
			],
			"Resource": "*"
		}
	]
}

EOF
}

resource "aws_iam_role_policy_attachment" "grant_logs_policy_attachment" {
  role       = aws_iam_role.nodes_role.name
  policy_arn = aws_iam_policy.grant_logs_policy.arn
}
