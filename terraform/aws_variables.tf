variable "aws_region" {
  description = "Region to deploy AWS"
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Base tags to apply to all AWS resources"
  type = object({
    Environment = string
    Owner = string
  })
}

variable "state_bucket" {
  description = "S3 bucket to store Terraform state"
  type = string
}