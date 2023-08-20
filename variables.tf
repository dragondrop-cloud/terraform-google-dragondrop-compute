# Variables with default values that most users will not want to update.
variable "cloud_concierge_container_path" {
  description = "Path to the cloud-concierge engine container used in the cloud run job."
  type        = string
  default     = "docker.io/dragondropcloud/cloud-concierge:latest"
}

variable "dragondrop_https_trigger_container_path" {
  description = "Path to the dragondrop engine container used in the cloud run service as the https endpoint."
  type        = string
  default     = "us-east4-docker.pkg.dev/dragondrop-prod/dragondrop-https-triggers/cloud-run-service:latest"
}

variable "cloud_run_max_instances" {
  description = "Maximum number of Cloud Run instances to be scaled up to handle incoming requests. This value should be set to at most 2."
  type        = string
  default     = 2
}

# User-defined variables
variable "region" {
  description = "GCP region into which resources will be deployed."
  type        = string
}

variable "project" {
  description = "GCP project name into which resources will be deployed."
  type        = string
}

variable "cloud_concierge_cloud_run_job_name" {
  description = "Name of the Cloud Run Job that hosts the cloud-concierge compute engine."
  type        = string
}

variable "gcs_state_bucket" {
  description = "Name of the GCS bucket used to store the state of the terraform deployment. Optional to specify."
  type        = string
  default     = "None"
}

variable "https_trigger_cloud_run_service_name" {
  description = "Name of the https trigger Cloud Run service that will trigger the dragondrop 'engine' hosted in a cloud run job."
  type        = string
}
