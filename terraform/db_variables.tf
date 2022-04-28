variable "db_root" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_root_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
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
}

variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = false
}

variable "db_port" {
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
}