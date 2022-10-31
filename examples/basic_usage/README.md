# Basic Usage

Basic quickstart for creating an RDS Instance using the defaults.

Example shows using Default Tags in the provider as well as passing additional tags into the resource.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Examples

```hcl
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

# Create RDS with default settings in Private Subnets, letting the module create a subnet group.
module "default-rds" {
  source  = "so1omon563/rds-instance/aws"
  version = "1.0.0"

  name                   = var.name
  subnet_ids             = data.aws_subnets.private_subnets.ids
  vpc_security_group_ids = [module.sg.security-group.id]

  # If you wish to be able to quickly delete the RDS instance, you can uncomment this. Otherwise, you will need to modify the RDS instance prior to deletion.
  #   deletion_protection = false

  tags = { example = "true" }
}
output "default-rds" { value = module.default-rds }
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.37.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_default-rds"></a> [default-rds](#module\_default-rds) | so1omon563/rds-instance/aws | 1.0.0 |
| <a name="module_sg"></a> [sg](#module\_sg) | so1omon563/security-group/aws | 1.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | so1omon563/vpc/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default-rds"></a> [default-rds](#output\_default-rds) | n/a |
| <a name="output_sg"></a> [sg](#output\_sg) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | n/a |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
