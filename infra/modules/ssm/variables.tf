variable "parameter_name" {
  description = "Name of the SSM parameter"
  type        = string
}

variable "app_secret" {
  description = "Application secret value"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}