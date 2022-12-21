variable "project_name" {
  description = "Project name of the corresponding project."
  type        = string
}

variable "project_number" {
  description = "Project number of the secret's project."
  type        = number
}

variable "secret_id" {
  description = "Name of the new secret to define."
  type        = string
}

variable "compute_service_account_email" {
  description = "Service account email with locked-down permissions for accessing resources related to dragondrop compute."
  type        = string
}
