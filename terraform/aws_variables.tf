variable "aws_region" {
  description = "Region to deploy AWS"
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Base tags to apply to all AWS resources"
  type = object({
    Environment = string
    Owner       = string
  })
}

variable "repo" {
  description = "Repo to get microservices"
  type        = string
  sensitive   = true
}

variable "secret_key_name" {
  description = "Name of secret storing database login"
  type        = string
  sensitive   = true
}