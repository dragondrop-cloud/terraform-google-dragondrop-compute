# Ensuring that the cloud run api is enabled.
resource "google_project_service" "sql_admin_api" {
  service            = "run.googleapis.com"
  project            = var.project
  disable_on_destroy = false
}

module "cloud_run_https_endpoint" {
  source = "./modules/cloud_run_https_endpoint"

  project = var.project
  region  = var.region

  cloud_run_max_instances                 = var.cloud_run_max_instances
  dragondrop_https_trigger_container_path = var.dragondrop_https_trigger_container_path
  cloud_concierge_cloud_run_job_name      = var.cloud_concierge_cloud_run_job_name
  https_trigger_cloud_run_service_name    = var.https_trigger_cloud_run_service_name
}

module "cloud_run_job" {
  source = "./modules/cloud_run_job"

  project                        = var.project
  region                         = var.region
  cloud_run_job_name             = var.cloud_concierge_cloud_run_job_name
  cloud_run_service_sa_email     = module.cloud_run_https_endpoint.service_sa_email
  cloud_concierge_container_path = var.cloud_concierge_container_path
  gcs_state_bucket               = var.gcs_state_bucket
}
