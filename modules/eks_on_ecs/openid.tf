/**
* This file create all the needed to have an OIDC provider
*
*
*/


data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}


resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint])
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer

  tags = local.default_tags
}



resource "aws_eks_identity_provider_config" "idp_config" {
  cluster_name = local.cluster_name
  tags         = local.default_tags
  oidc {
    client_id                     = substr(aws_eks_cluster.cluster.identity.0.oidc.0.issuer, -32, -1)
    identity_provider_config_name = local.cluster_name
    issuer_url                    = "https://${aws_iam_openid_connect_provider.cluster.url}"

  }
}
