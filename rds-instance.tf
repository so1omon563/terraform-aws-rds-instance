resource "aws_db_instance" "db" {

  allocated_storage           = var.allocated_storage
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  availability_zone           = var.availability_zone
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  ca_cert_identifier          = var.ca_cert_identifier
  character_set_name          = var.character_set_name
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  customer_owned_ip_enabled   = var.customer_owned_ip_enabled
  db_name                     = var.db_name

  db_subnet_group_name     = var.db_subnet_group_name == null ? module.subnet_group[0].subnet_group.name : var.db_subnet_group_name
  delete_automated_backups = var.delete_automated_backups
  deletion_protection      = var.deletion_protection
  domain                   = var.domain

  domain_iam_role_name = var.domain != null && var.domain_iam_role_name != null ? var.domain_iam_role_name : var.domain != null && var.domain_iam_role_name == null ? aws_iam_role.rds.name : null

  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  engine                                = var.engine
  engine_version                        = var.engine_version
  final_snapshot_identifier             = format("%s-final", local.identifier)
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  identifier                            = local.identifier
  instance_class                        = var.instance_class
  iops                                  = var.iops
  kms_key_id                            = var.kms_key_id
  license_model                         = var.license_model
  maintenance_window                    = var.maintenence_window
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_interval > 0 && var.monitoring_role_arn != null ? var.monitoring_role_arn : var.monitoring_interval > 0 && var.monitoring_role_arn == null ? aws_iam_role.rds.arn : null
  multi_az                              = var.multi_az
  nchar_character_set_name              = var.nchar_character_set_name
  network_type                          = var.network_type
  option_group_name                     = var.option_group_name
  parameter_group_name                  = var.parameter_group_name
  password                              = random_string.master_pw.result
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  port                                  = var.port
  publicly_accessible                   = var.publicly_accessible
  replica_mode                          = var.replica_mode
  replicate_source_db                   = var.replicate_source_db
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  timezone                              = var.timezone
  username                              = var.username
  vpc_security_group_ids                = var.vpc_security_group_ids
  tags                                  = merge({ "Name" = local.name }, local.tags)

  lifecycle {
    ignore_changes = [
      password,
      username,
    ]

  }
}
