variable "region" {
  description = "Region to deploy VPC into"
  type        = string
  sensitive   = false
}

variable "vpc_cidr_block" {
  description = "CIDR block address for VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "private_subnets" {
  type = list(string)
  validation {
    condition = alltrue([
      for s in var.private_subnets : can(cidrnetmask(s))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
  default = []
}

variable "public_subnets" {
  type = list(string)
  validation {
    condition = alltrue([
      for s in var.public_subnets : can(cidrnetmask(s))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
  default = []
}

variable "db_subnets" {
  type = list(string)
  validation {
    condition = alltrue([
      for s in var.db_subnets : can(cidrnetmask(s))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
  default = []
}

variable "security_group_ingress" {
  description = "List of maps of ingress rules to set on the security group"
  type = list(object({
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = []
}

variable "security_group_egress" {
  description = "List of maps of engress rules to set on the security group"
  type = list(object({
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}