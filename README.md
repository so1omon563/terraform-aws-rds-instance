# RDS Instance

Module to create an RDS Instance with some default security best practices. By default, it creates a DB Subnet Group from a list of Subnet IDs. Can also use the `subnet_group` submodule to create a custom Subnet Group if desired.

By default, will create a MySQL 8.0 DB on a db.t2.large instance.

**NOTE: This module creates a random password for the DB instance. The default password in kept in the tfstate, and may be readable in the outputs. This default password should be changed outside of Terraform IMMEDIATELY**

This module ignores changes to the `password` and `username` after creation, so they will not be updated in the DB instance. This means the `password` and `username` must be updated outside of Terraform.

See the [AWS official documentation](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html) for detailed information about the options.

## Upgrading from previous versions

The 1.0 release of this module is a major upgrade from previous versions. If run directly against an RDS instance created by a previous version of this module, Terraform will fail due to the Subnet Group needing to be recreated. To avoid this, you must first re-import the existing Subnet Group into this module, then run the upgrade.

Example, assuming you are calling this module as `rds`:

```shell

terraform import module.rds.module.subnet_group[0].aws_db_subnet_group.db <subnet-group-name>

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Auto-generated technical documentation is created using [`terraform-docs`](https://terraform-docs.io/)
## Examples

```hcl
# See examples under the top level examples directory for more information on how to use this module.
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.37.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnet_group"></a> [subnet\_group](#module\_subnet\_group) | ./modules/subnet_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_iam_role.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.directory_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_id.db_identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_string.master_pw](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | (Required unless a `snapshot_identifier` or `replicate_source_db` is provided) The allocated storage in gibibytes. If `max_allocated_storage` is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs. If `replicate_source_db` is set, the value is ignored during the creation of the instance. | `number` | `100` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible. | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is `false`. See [Amazon RDS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.Modifying.html) for more information. | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default is `true`. | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The AZ for the RDS instance. If not specified, AWS will choose one for you. | `string` | `null` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. Must be between `0` and `35`. Must be greater than `0` if the database is used as a source for a [Read Replica](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html). | `number` | `7` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: `09:46-10:16`. Must not overlap with `maintenance_window`. | `string` | `"08:00-08:30"` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | The identifier of the CA certificate for the DB instance. | `string` | `null` | no |
| <a name="input_character_set_name"></a> [character\_set\_name](#input\_character\_set\_name) | The character set name to use for DB encoding in Oracle and Microsoft SQL instances (collation). This can't be changed. See [Oracle Character Sets Supported in Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html) or [Server-Level Collation for Microsoft SQL Server](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.Collation.html) for more information. | `string` | `null` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy all Instance tags to snapshots (including the final snapshot if `final_snapshot_identifier` is specified). | `bool` | `false` | no |
| <a name="input_create_subnet_group"></a> [create\_subnet\_group](#input\_create\_subnet\_group) | Whether to create a DB subnet group. If true, a DB subnet group will be created using the subnets specified in `var.subnet_ids`. If false, you must provide a valid DB subnet group name in `var.db_subnet_group_name`. | `bool` | `true` | no |
| <a name="input_customer_owned_ip_enabled"></a> [customer\_owned\_ip\_enabled](#input\_customer\_owned\_ip\_enabled) | Indicates whether to enable a customer-owned IP address (CoIP) for an RDS on Outposts DB instance. See [CoIP for RDS on Outposts](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-on-outposts.html#rds-on-outposts.coip) for more information. | `bool` | `false` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database to create when the DB instance is created. If this parameter is not specified, no database is created in the DB instance. Note that this does not apply for Oracle or SQL Server engines. See the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_LaunchingInstance.html#CHAP_LaunchingInstance.DatabaseName) for more information. If you are providing an Oracle db name, it needs to be in all upper case. Cannot be specified for a replica. | `string` | `null` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | A DB subnet group to associate with this DB instance. Either this, or `var.subnet_ids` must be provided. If both are unspecified, the RDS instance will be created in the `default` VPC, or in EC2 Classic, if available. When working with read replicas, it should be specified only if the source database specifies an instance in another AWS Region. See [DBSubnetGroupName in API action CreateDBInstanceReadReplica](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstanceReadReplica.html) for additional read replica contraints. | `string` | `null` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Specifies whether to remove automated backups immediately after the DB instance is deleted. | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`. | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The Active Directory directory ID to create the DB instance in. See [the AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/kerberos-authentication.html) for more information. | `string` | `null` | no |
| <a name="input_domain_iam_role_name"></a> [domain\_iam\_role\_name](#input\_domain\_iam\_role\_name) | The name of the IAM role to be used when making API calls to the Directory Service if you don't wish to use the role created by this module. If a `domain` is specified, and no `domain_iam_role_name` is specified, then the IAM role created by this module will be used. | `string` | `null` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to export to CloudWatch. If omitted, no logs will be exported. Valid values (depending on `engine`). MySQL and MariaDB: `audit`, `error`, `general`, `slowquery`. PostgreSQL: `postgresql`, `upgrade`. MSSQL: `agent`, `error`. Oracle: `alert`, `audit`, `listener`, `trace`. | `list(string)` | <pre>[<br>  "error"<br>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | (Required unless a `snapshot_identifier` or `replicate_source_db` is provided) The database engine to use. For supported values, see the Engine parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). Cannot be specified for a replica. Note that for Amazon Aurora instances the engine must match the [DB cluster's](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) engine. For information on the difference between the available Aurora MySQL engines see [Comparison between Aurora MySQL 1 and Aurora MySQL 2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraMySQLReleaseNotes/AuroraMySQL.Updates.20180206.html) in the Amazon RDS User Guide. | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use. If `auto_minor_version_upgrade` is enabled, you can provide a prefix of the version such as `5.7` (for `5.7.10`). The actual engine version used is returned in the attribute `engine_version_actual`. For supported values, see the EngineVersion parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). Note that for Amazon Aurora instances the engine must match the [DB cluster's](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) engine version. Cannot be specified for a replica. | `string` | `"8.0"` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | `bool` | `true` | no |
| <a name="input_identifier_override"></a> [identifier\_override](#input\_identifier\_override) | Used if there is a need to specify an identifier outside of the standardized nomenclature. For example, if importing an instance that doesn't follow the standard naming formats. | `string` | `null` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance. | `string` | `"db.t2.large"` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of `io1`. Must be an integer greater than 1000. | `number` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. | `string` | `null` | no |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model information for this DB instance (required for some DB engines, like `Oracle SE1`). See [LicenseModel in API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). | `string` | `null` | no |
| <a name="input_maintenence_window"></a> [maintenence\_window](#input\_maintenence\_window) | The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`. Eg: `Mon:00:00-Mon:03:00`.  See [MaintenanceWindow in API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). | `string` | `"Sun:09:00-Sun:09:30"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to `allocated_storage`. Must be greater than or equal to `allocated_storage` or `0` to disable Storage Autoscaling. | `number` | `0` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify `0`. Valid Values: 0, 1, 5, 10, 15, 30, 60. | `number` | `60` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. if you don't wish to use the role created by this module. If no value is specified, then the IAM role created by this module will be used. You can find more information on the [AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html) to see what IAM permissions are needed to allow Enhanced Monitoring for RDS Instances.. | `string` | `null` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Short, descriptive name of the environment. All resources will be named using this value as a prefix. | `string` | n/a | yes |
| <a name="input_nchar_character_set_name"></a> [nchar\_character\_set\_name](#input\_nchar\_character\_set\_name) | The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances. This can't be changed. See [Oracle Character Sets Supported in Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html) for more info. | `string` | `null` | no |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | The optional network type of the DB instance. Valid values: `IPV4`, `DUAL`. | `string` | `null` | no |
| <a name="input_option_group_name"></a> [option\_group\_name](#input\_option\_group\_name) | The name of the option group to associate. | `string` | `null` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | The name of the DB parameter group to associate. If omitted, Terraform will assign the default parameter group for the specified engine. | `string` | `null` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled. | `bool` | `true` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to `true`. Once KMS key is set, it can never be changed. | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years), or a multiple of `31`. When specifying `performance_insights_retention_period`, `performance_insights_enabled` needs to be set to `true`. | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections. If not specified, the default port for the engine is used. | `number` | `null` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Specifies if the RDS instance is publicly accessible. | `bool` | `false` | no |
| <a name="input_replica_mode"></a> [replica\_mode](#input\_replica\_mode) | Specifies whether the replica is in either `mounted` or `open-read-only` mode. This attribute is only supported by Oracle instances. Oracle replicas operate in `open-read-only` mode unless otherwise specified. See [Oracle Read Replica](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/oracle-read-replicas.html) for more information. | `string` | `null` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the `identifier` of another Amazon RDS Database to replicate (if replicating within a single region) or ARN of the Amazon RDS Database to replicate (if replicating cross-region). Note that if you are creating a cross-region replica of an encrypted database you will also need to specify a `kms_key_id`. See [DB Instance Replication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html) and [Working with PostgreSQL and MySQL Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html) for more information on using Replication. | `string` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from `final_snapshot_identifier`. | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05. | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted. Note that if you are creating a cross-region read replica this field is ignored and you should instead declare `kms_key_id` with a valid ARN. | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of `standard` (magnetic), `gp2` (general purpose SSD), or `io1` (provisioned IOPS SSD). The default is `io1` if `iops` is specified, `gp2` if not. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs to create a DB subnet group in. Either this, or `var.db_subnet_group_name` must be provided. Combines with `var.create_subnet_group` to determine what subnets to create the DB subnet group in. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider. | `map(string)` | `{}` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | The timezone of the DB instance. Currently only supported by Microsoft SQL Server. Can only be set on creation. Timezone names always end in the letter 'Z'. See [MSSQL User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.TimeZone) for more information. | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | One word descriptive type - To be appended to the `name` variable to name the resources. Should be something descriptive like `app`, etc. | `string` | `null` | no |
| <a name="input_use_unique_identifier"></a> [use\_unique\_identifier](#input\_use\_unique\_identifier) | Append a random hex to the identifier of the RDS Instance. This can help prevent problems when creating a new RDS Instance in the same region as an existing one with the same name. | `bool` | `true` | no |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user. Required unless a `snapshot_identifier` or `replicate_source_db` is provided. Cannot be specified for a replica. Note that this may show up in logs, and it will be stored in the state file. | `string` | `"root"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of Security Group IDs to attach to the RDS instance. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_CHANGE_PASSWORD"></a> [CHANGE\_PASSWORD](#output\_CHANGE\_PASSWORD) | n/a |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | Collection of outputs for the created IAM Role. |
| <a name="output_rds_instance"></a> [rds\_instance](#output\_rds\_instance) | Collection of outputs for the created DB Instance. Does not contain `password` or `username` values. |
| <a name="output_subnet_group"></a> [subnet\_group](#output\_subnet\_group) | Collection of outputs for the created DB Subnet Group. |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
