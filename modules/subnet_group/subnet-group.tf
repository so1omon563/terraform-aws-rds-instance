resource "aws_db_subnet_group" "db" {
  name       = local.name
  subnet_ids = var.subnet_ids
  tags       = merge({ "Name" = local.name }, local.tags)
}
