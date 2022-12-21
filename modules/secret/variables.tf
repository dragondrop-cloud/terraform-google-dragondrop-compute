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

variable "dragondrop_compute_service_account" {
  description = "Service account granted to grant read permissions to the secret."
  type        = string
}
