variable "name" {
  type        = string
  description = "Short, descriptive name of the environment. All resources will be named using this value as a prefix. Either this, or `var.name_override` must be provided."
  default     = null
}

variable "name_override" {
  type        = string
  description = "Used if there is a need to specify a name outside of the standardized nomenclature. For example, if importing a subnet group that doesn't follow the standard naming formats."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the DB subnet group."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider."
  default     = {}
}
