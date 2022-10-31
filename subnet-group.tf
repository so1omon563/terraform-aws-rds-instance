module "subnet_group" {
  count  = var.subnet_ids == null ? 0 : 1
  source = "./modules/subnet_group"

  name       = local.name
  subnet_ids = var.subnet_ids

  tags = local.tags
}
