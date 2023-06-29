
variable "region" {
  description = "region aws"
  type        = string

}

variable "environment" {
  description = "environment"
  type        = string

}


variable "hosted_zone_id" {
  description = "dns hosted_zone_id"
  type        = string
  default     = "" //means not used
}


variable "capacity_type" {
  description = "capacity_type for EC2 instances. can be ON_DEMAND or SPOT"
  default     = "SPOT"
  type        = string
}

variable "instance_types" {
  description = "instance_types for EC2 instances"
  default     = "t3.large"
  type        = string
}

variable "disk_size" {
  description = "disk_size for EC2 instances"
  default     = 40
  type        = number
}


variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "private_subnets_cidr_blocks" {
  description = "CIDR block for the private subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type        = list(any)
}

variable "public_subnets_cidr_blocks" {
  description = "CIDR block for the public subnet"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  type        = list(any)
}
