locals {
  tags       = var.tags
  region     = data.aws_region.current.id
  account_id = data.aws_caller_identity.current.account_id

  name = var.type != null ? format("%s-%s-%s", var.name, var.type, var.engine) : format("%s-rds-%s", var.name, var.engine)

  identifier = var.identifier_override != null ? var.identifier_override : var.use_unique_identifier ? format("%s-%s", local.name, random_id.db_identifier.hex) : local.name
}
