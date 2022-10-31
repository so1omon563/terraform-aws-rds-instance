locals {
  tags = var.tags
  name = var.name_override != null ? var.name_override : format("%s-subnet-group", var.name)
}
