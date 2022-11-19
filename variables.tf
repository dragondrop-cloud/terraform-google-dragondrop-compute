variable "region" {
  description = "GCP region into which resources will be deployed."
  type = string
}

variable "project" {
  description = "GCP project into which resources will be deployed."
  type = string
}

variable "cloud_run_max_instances" {
  description = "Maximum number of cloud run instances to be scaled up to handle incoming requests. This value should be set to at most 2."
  type = string
}

variable "https_trigger_cloud_run_service_name" {
  description = "Name of the https trigger cloud run service that will trigger the dragondrop 'engine' hosted in a cloud run job."
  type = string
}

variable "service_account_name" {
  description = "Name of the service account with exclusively Cloud Run Job invocation privileges that serves as the service account for the HTTPS trigger Cloud Run Job."
  type = string
}
