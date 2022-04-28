variable "Environment" {
  description = "Production enviroment"
  type        = string
  default     = "dev"
  sensitive   = true
}

variable "creator" {
  description = "User that provisioned resource"
  type        = string
  sensitive   = false
}