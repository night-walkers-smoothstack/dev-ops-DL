variable "engine" {
  type        = string
  description = "what kind of database engine"
}

variable "engine_version" {
  type        = string
  description = "what version of database engine"
}

variable "db_root_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_root_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  validation {
    condition = (
      can(regex("[A-Z]", var.db_root_password)) &&
      can(regex("[a-z]", var.db_root_password)) &&
      can(regex("[[:punct:]]", var.db_root_password))
      # TODO account for unicode input
    )
    error_message = "Password must contain at least one each uppercase letter, lowercase letter, number, and any of the following characters '!-/:-@[-`{-~'."
  }

}

variable "db_username" {
  description = "Database client username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database client password"
  type        = string
  sensitive   = true
  validation {
    condition = (
      can(regex("[A-Z]", var.db_password)) &&
      can(regex("[a-z]", var.db_password)) &&
      can(regex("[[:punct:]]", var.db_password))
      # TODO account for unicode input
    )
    error_message = "Password must contain at least one each uppercase letter, lowercase letter, number, and any of the following characters '!-/:-@[-`{-~'."
  }
}

variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = false
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 3306
  sensitive   = false
}

variable "instance_class" {
  description = "DB compute instance"
  type        = string
  default     = "db.t3.micro"
  validation {
    condition     = can(regex("^db.", var.instance_class))
    error_message = "The instance_class value must be a valid RDS db instance, starting with \"db\"."
  }
  sensitive = false
}

variable "identifier" {
  type        = string
  description = " Name of RDS instance."
  sensitive   = false
}

variable "storage_type" {
  type        = string
  description = "type of storage to deploy db instance to"
  default     = "gp2"
  sensitive   = false
}

variable "allocated_storage" {
  type        = number
  description = "how much storage to be allocated to db"
  sensitive   = false
}

variable "security_groups_ids" {
  type        = list(string)
  description = "list of vps security group ids accessable to db"
  sensitive   = true
}

variable "publicly_accessible" {
  type        = bool
  description = "whether the db is accessable to the internet or not"
  default     = false
  sensitive   = false
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_name" {
  type        = string
  description = "name of subnet group to deploy db into"
  sensitive   = false
}