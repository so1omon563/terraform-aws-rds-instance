output "CHANGE_PASSWORD" {
  value = "CHANGE THE DEFAULT PASSWORD!"
}

output "iam_role" {
  value       = { for key, value in aws_iam_role.rds : key => value }
  description = "Collection of outputs for the created IAM Role."
}

output "rds_instance" {
  value       = { for key, value in aws_db_instance.db : key => value if !contains(["password", "username"], key) }
  description = "Collection of outputs for the created DB Instance. Does not contain `password` or `username` values."
}

output "subnet_group" {
  value       = { for key, value in module.subnet_group : key => value }
  description = "Collection of outputs for the created DB Subnet Group."
}
