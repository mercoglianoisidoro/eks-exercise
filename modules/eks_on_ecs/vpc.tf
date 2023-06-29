/**
* networking
*/


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "vpc-for-${local.cluster_name}"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets  = var.public_subnets_cidr_blocks
  # azs             = ["${var.region}-1a"]
  azs                     = ["${var.region}a", "${var.region}b", "${var.region}c"]
  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true

  tags = merge(
    local.default_tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

}

