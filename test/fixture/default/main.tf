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

# Create RDS with default settings in Private Subnets, letting the module create a subnet group.
module "default-rds" {
  depends_on = [
    module.vpc
  ]
  source = "../../../"

  name                   = var.name
  subnet_ids             = data.aws_subnets.private_subnets.ids
  vpc_security_group_ids = [module.sg.security-group.id]
  deletion_protection    = false

  tags = { example = "true" }
}
output "default-rds" { value = module.default-rds }

# Create another subnet group to verify that the module can use an existing subnet group.
# Using same subnets as the default RDS instance.
module "subnet_group" {
  depends_on = [
    module.vpc
  ]
  source = "../../../modules//subnet_group"

  name_override = "rds-override-subnet-group"
  subnet_ids    = data.aws_subnets.private_subnets.ids

  tags = { example = "true" }
}

# Create RDS with default settings in a named Subnet Group.
module "subnet-group-rds" {
  depends_on = [
    module.vpc
  ]
  source = "../../../"

  name                   = var.name
  create_subnet_group    = false
  db_subnet_group_name   = module.subnet_group.subnet_group.name
  vpc_security_group_ids = [module.sg.security-group.id]

  deletion_protection = false

  tags = { example = "true" }
}
output "subnet-group-rds" { value = module.subnet-group-rds }
