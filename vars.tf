variable "name" {
  type        = string
  description = "Short, descriptive name of the environment. All resources will be named using this value as a prefix."
}

variable "allocated_storage" {
  type        = number
  description = "(Required unless a `snapshot_identifier` or `replicate_source_db` is provided) The allocated storage in gibibytes. If `max_allocated_storage` is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs. If `replicate_source_db` is set, the value is ignored during the creation of the instance."
  default     = 100
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is `false`. See [Amazon RDS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.Modifying.html) for more information."
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default is `true`."
  default     = true
}

variable "availability_zone" {
  type        = string
  description = "The AZ for the RDS instance. If not specified, AWS will choose one for you."
  default     = null
}

variable "backup_retention_period" {
  type        = number
  description = "The days to retain backups for. Must be between `0` and `35`. Must be greater than `0` if the database is used as a source for a [Read Replica](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)."
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: `09:46-10:16`. Must not overlap with `maintenance_window`."
  default     = "08:00-08:30"
}

variable "ca_cert_identifier" {
  type        = string
  description = "The identifier of the CA certificate for the DB instance."
  default     = null
}

variable "character_set_name" {
  type        = string
  description = "The character set name to use for DB encoding in Oracle and Microsoft SQL instances (collation). This can't be changed. See [Oracle Character Sets Supported in Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html) or [Server-Level Collation for Microsoft SQL Server](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.Collation.html) for more information."
  default     = null
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy all Instance tags to snapshots (including the final snapshot if `final_snapshot_identifier` is specified)."
  default     = false
}

variable "create_subnet_group" {
  type        = bool
  description = "Whether to create a DB subnet group. If true, a DB subnet group will be created using the subnets specified in `var.subnet_ids`. If false, you must provide a valid DB subnet group name in `var.db_subnet_group_name`."
  default     = true
}

variable "customer_owned_ip_enabled" {
  type        = bool
  description = "Indicates whether to enable a customer-owned IP address (CoIP) for an RDS on Outposts DB instance. See [CoIP for RDS on Outposts](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-on-outposts.html#rds-on-outposts.coip) for more information."
  default     = false
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created. If this parameter is not specified, no database is created in the DB instance. Note that this does not apply for Oracle or SQL Server engines. See the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_LaunchingInstance.html#CHAP_LaunchingInstance.DatabaseName) for more information. If you are providing an Oracle db name, it needs to be in all upper case. Cannot be specified for a replica."
  default     = null
}

variable "db_subnet_group_name" {
  type        = string
  description = "A DB subnet group to associate with this DB instance. Either this, or `var.subnet_ids` must be provided. If both are unspecified, the RDS instance will be created in the `default` VPC, or in EC2 Classic, if available. When working with read replicas, it should be specified only if the source database specifies an instance in another AWS Region. See [DBSubnetGroupName in API action CreateDBInstanceReadReplica](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstanceReadReplica.html) for additional read replica contraints."
  default     = null
}

variable "delete_automated_backups" {
  type        = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  default     = true
}

variable "domain" {
  type        = string
  description = "The Active Directory directory ID to create the DB instance in. See [the AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/kerberos-authentication.html) for more information."
  default     = null
}

variable "domain_iam_role_name" {
  type        = string
  description = "The name of the IAM role to be used when making API calls to the Directory Service if you don't wish to use the role created by this module. If a `domain` is specified, and no `domain_iam_role_name` is specified, then the IAM role created by this module will be used."
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to CloudWatch. If omitted, no logs will be exported. Valid values (depending on `engine`). MySQL and MariaDB: `audit`, `error`, `general`, `slowquery`. PostgreSQL: `postgresql`, `upgrade`. MSSQL: `agent`, `error`. Oracle: `alert`, `audit`, `listener`, `trace`."
  default     = ["error"]
}

variable "engine" {
  type        = string
  description = "(Required unless a `snapshot_identifier` or `replicate_source_db` is provided) The database engine to use. For supported values, see the Engine parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). Cannot be specified for a replica. Note that for Amazon Aurora instances the engine must match the [DB cluster's](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) engine. For information on the difference between the available Aurora MySQL engines see [Comparison between Aurora MySQL 1 and Aurora MySQL 2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraMySQLReleaseNotes/AuroraMySQL.Updates.20180206.html) in the Amazon RDS User Guide."
  default     = "mysql"
}

variable "engine_version" {
  type        = string
  description = "The engine version to use. If `auto_minor_version_upgrade` is enabled, you can provide a prefix of the version such as `5.7` (for `5.7.10`). The actual engine version used is returned in the attribute `engine_version_actual`. For supported values, see the EngineVersion parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). Note that for Amazon Aurora instances the engine must match the [DB cluster's](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) engine version. Cannot be specified for a replica."
  default     = "8.0"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = true
}

variable "identifier_override" {
  type        = string
  description = "Used if there is a need to specify an identifier outside of the standardized nomenclature. For example, if importing an instance that doesn't follow the standard naming formats."
  default     = null
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance."
  default     = "db.t2.large"
}

variable "iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of `io1`. Must be an integer greater than 1000."
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN."
  default     = null
}

variable "license_model" {
  type        = string
  description = "License model information for this DB instance (required for some DB engines, like `Oracle SE1`). See [LicenseModel in API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html)."
  default     = null
}

variable "maintenence_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`. Eg: `Mon:00:00-Mon:03:00`.  See [MaintenanceWindow in API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html)."
  default     = "Sun:09:00-Sun:09:30"
}

variable "max_allocated_storage" {
  type        = number
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to `allocated_storage`. Must be greater than or equal to `allocated_storage` or `0` to disable Storage Autoscaling."
  default     = 0
}

variable "monitoring_interval" {
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify `0`. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  default     = 60
}

variable "monitoring_role_arn" {
  type        = string
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. if you don't wish to use the role created by this module. If no value is specified, then the IAM role created by this module will be used. You can find more information on the [AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html) to see what IAM permissions are needed to allow Enhanced Monitoring for RDS Instances.."
  default     = null
}

variable "multi_az" {
  type        = bool
  description = "Specifies if the RDS instance is multi-AZ."
  default     = true
}

variable "nchar_character_set_name" {
  type        = string
  description = "The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances. This can't be changed. See [Oracle Character Sets Supported in Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html) for more info."
  default     = null
}

variable "network_type" {
  type        = string
  description = "The optional network type of the DB instance. Valid values: `IPV4`, `DUAL`."
  validation {
    condition     = var.network_type == null ? true : contains(["IPV4", "DUAL"], var.network_type)
    error_message = "Valid values for network_type are limited to (IPV4, DUAL)."
  }
  default = null
}

variable "option_group_name" {
  type        = string
  description = "The name of the option group to associate."
  default     = null
}

variable "parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group to associate. If omitted, Terraform will assign the default parameter group for the specified engine."
  default     = null
}

# Going to autogenerate a default password
# variable "password" {
#   type        = string
#   description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
#   default     = null
# }

variable "performance_insights_enabled" {
  type        = bool
  description = "Specifies whether Performance Insights is enabled."
  default     = true
}

variable "performance_insights_kms_key_id" {
  type        = string
  description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to `true`. Once KMS key is set, it can never be changed."
  default     = null
}

variable "performance_insights_retention_period" {
  type        = number
  description = "The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years), or a multiple of `31`. When specifying `performance_insights_retention_period`, `performance_insights_enabled` needs to be set to `true`."
  default     = 7
}

variable "port" {
  type        = number
  description = "The port on which the DB accepts connections. If not specified, the default port for the engine is used."
  default     = null
}

variable "publicly_accessible" {
  type        = bool
  description = "Specifies if the RDS instance is publicly accessible."
  default     = false
}

variable "replica_mode" {
  type        = string
  description = "Specifies whether the replica is in either `mounted` or `open-read-only` mode. This attribute is only supported by Oracle instances. Oracle replicas operate in `open-read-only` mode unless otherwise specified. See [Oracle Read Replica](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/oracle-read-replicas.html) for more information."
  default     = null
}

variable "replicate_source_db" {
  type        = string
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the `identifier` of another Amazon RDS Database to replicate (if replicating within a single region) or ARN of the Amazon RDS Database to replicate (if replicating cross-region). Note that if you are creating a cross-region replica of an encrypted database you will also need to specify a `kms_key_id`. See [DB Instance Replication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html) and [Working with PostgreSQL and MySQL Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html) for more information on using Replication."
  default     = null
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from `final_snapshot_identifier`."
  default     = true
}

variable "snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  default     = null
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB instance is encrypted. Note that if you are creating a cross-region read replica this field is ignored and you should instead declare `kms_key_id` with a valid ARN."
  default     = true
}

variable "storage_type" {
  type        = string
  description = "One of `standard` (magnetic), `gp2` (general purpose SSD), or `io1` (provisioned IOPS SSD). The default is `io1` if `iops` is specified, `gp2` if not."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs to create a DB subnet group in. Either this, or `var.db_subnet_group_name` must be provided. Combines with `var.create_subnet_group` to determine what subnets to create the DB subnet group in."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider."
  default     = {}
}

variable "timezone" {
  type        = string
  description = "The timezone of the DB instance. Currently only supported by Microsoft SQL Server. Can only be set on creation. Timezone names always end in the letter 'Z'. See [MSSQL User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.TimeZone) for more information."
  default     = null
}

variable "type" {
  type        = string
  description = "One word descriptive type - To be appended to the `name` variable to name the resources. Should be something descriptive like `app`, etc."
  default     = null
}

variable "use_unique_identifier" {
  type        = bool
  description = "Append a random hex to the identifier of the RDS Instance. This can help prevent problems when creating a new RDS Instance in the same region as an existing one with the same name."
  default     = true
}

variable "username" {
  type        = string
  description = "Username for the master DB user. Required unless a `snapshot_identifier` or `replicate_source_db` is provided. Cannot be specified for a replica. Note that this may show up in logs, and it will be stored in the state file."
  default     = "root"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of Security Group IDs to attach to the RDS instance."
  default     = null
}
