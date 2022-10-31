output "subnet_group" {
  value       = { for key, value in aws_db_subnet_group.db : key => value }
  description = "Collection of outputs for the created DB Subnet Group."
}
