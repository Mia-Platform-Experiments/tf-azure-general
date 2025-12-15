variable "service_name" {
  description = "The name of the service (e.g., payment-service). Used for resource naming."
  type        = string
  default     = "%spec.service_name%"
}

variable "resource_group_name" {
  description = "The name of the existing Resource Group in Azure."
  type        = string
  default     = "%spec.resource_group_name%"
}

variable "location" {
  description = "The Azure region to deploy to."
  type        = string
  default     = "%spec.location%"
}

variable "performance_profile" {
  description = "The performance tier selected by the developer (sandbox, development, production)."
  type        = string
  default     = "%spec.performance_profile%"

  validation {
    condition     = contains(["sandbox", "development", "production"], var.performance_profile)
    error_message = "Performance profile must be one of: sandbox, development, production."
  }
}

variable "tech_stack" {
  description = "The runtime stack for the application."
  type        = string
  default     = "%spec.tech_stack%"
}
