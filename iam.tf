resource "aws_iam_role" "rds" {
  name = local.identifier
  tags = var.tags

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Attach AWS Managed Enhanced Montoring policy
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds.name
}

# Attach AWS Managed Directory Service policy
resource "aws_iam_role_policy_attachment" "directory_service" {
  count      = var.domain != null && var.domain_iam_role_name == null ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSDirectoryServiceAccess"
  role       = aws_iam_role.rds.name
}
