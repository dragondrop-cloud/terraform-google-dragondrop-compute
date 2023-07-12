variable "project" {
  description = "Project name for the cloud run job."
  type        = string
}

variable "region" {
  description = "Project region for the cloud run job."
  type        = string
}

variable "cloud_concierge_container_path" {
  description = "Path to the cloud-concierge engine container used in the cloud run job."
  type        = string
}

variable "dragondrop_compute_service_account_email" {
  description = "Service account granted to grant read permissions to the secret."
  type        = string
}

variable "cloud_run_job_name" {
  description = "Name of the Cloud Run Job that will host the dragondrop core engine."
  type        = string
}
