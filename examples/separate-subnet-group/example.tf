variable "name" {}

provider "aws" {
  default_tags {
    tags = {
      environment = "dev"
      terraform   = "true"
      kitchen     = "true"
    }
  }
}

# Create VPC
module "vpc" {
  source  = "so1omon563/vpc/aws"
  version = "1.0.0"

  name = var.name
  tags = { example = "true" }
}

output "vpc" { value = module.vpc }

# Get information about Private subnets in VPC
data "aws_subnets" "private_subnets" {
  depends_on = [module.vpc]
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    network = "private"
  }
}

# Get other info about VPC
data "aws_vpc" "vpc" {
  id = module.vpc.vpc_id
}

# Create Security Group with some rules
module "sg" {
  source  = "so1omon563/security-group/aws"
  version = "1.0.0"

  name   = var.name
  vpc_id = module.vpc.vpc_id
  tags   = { example = "true" }

  rules = {
    mysql = {
      description              = "MySQL access from VPC CIDR block"
      reciprocal_egress        = false
      type                     = "ingress"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "TCP"
      cidr_blocks              = [data.aws_vpc.vpc.cidr_block]
      self                     = false
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
  }
}

output "sg" { value = module.sg }

# Create a subnet group to verify that the module can use an existing subnet group.
module "subnet_group" {
  source = "../../../modules//subnet_group"

  name_override = "rds-override-subnet-group"
  subnet_ids    = data.aws_subnets.private_subnets.ids

  tags = { example = "true" }
}

# Create RDS with default settings in a named Subnet Group.
module "subnet-group-rds" {
  source  = "so1omon563/rds-instance/aws"
  version = "0.0.1"

  name                   = var.name
  db_subnet_group_name   = module.subnet_group.subnet_group.name
  vpc_security_group_ids = [module.sg.security-group.id]

  tags = { example = "true" }
}
output "subnet-group-rds" { value = module.subnet-group-rds }
