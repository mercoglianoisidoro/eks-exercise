provider "aws" {
  region = var.region
}


module "eks_cluster" {
  source             = "../modules/eks_on_ecs"
  environment        = var.environment
  region             = var.region
  hosted_zone_id     = ""
  instance_types     = "t3.xlarge"
  capacity_type      = "SPOT"
  nodes_desired_size = 2
  nodes_min_size     = 2

  # capacity_type  = "ON_DEMAND"

}
