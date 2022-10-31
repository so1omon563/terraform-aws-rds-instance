module "subnet_group" {
  count  = var.create_subnet_group ? 1 : 0
  source = "./modules/subnet_group"

  name       = local.name
  subnet_ids = var.subnet_ids

  tags = local.tags
}
