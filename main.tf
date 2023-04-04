# Ensuring that the cloud run api is enabled.
resource "google_project_service" "sql_admin_api" {
  service            = "run.googleapis.com"
  project            = var.project
  disable_on_destroy = false
}

resource "google_service_account" "cloud_run_service_account" {
  account_id  = var.service_account_name
  description = "Service accounts used by the Cloud Run Services and Jobs that host the dragondrop.cloud service."
  project     = var.project
}

// Custom role for the service account, the minimum amount needed to update and invoke jobs
resource "google_project_iam_custom_role" "dragondrop-https-trigger-role" {
  project     = var.project
  role_id     = "dragondropHTTPSTriggerRole"
  title       = "dragondrop HTTPS Trigger Role"
  description = "Role for the dragondrop https trigger to update and invoke Cloud Run Jobs."
  permissions = ["iam.serviceAccounts.actAs", "run.executions.get", "run.jobs.get", "run.jobs.run", "run.jobs.update"]
}

// Once supported by Terraform, can make this a member only of the cloud run job, until then, this as restrictive
// as can be while still controlled by Terraform.
resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project
  role    = google_project_iam_custom_role.dragondrop-https-trigger-role.id
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}


module "cloud_run_job" {
  source = "./modules/cloud_run_job"

  project                                  = var.project
  region                                   = var.region
  cloud_run_job_name                       = var.dragondrop_engine_cloud_run_job_name
  dragondrop_compute_service_account_email = google_service_account.cloud_run_service_account.email
  dragondrop_engine_container_path         = var.dragondrop_engine_container_path
}

module "cloud_run_https_endpoint" {
  source = "./modules/cloud_run_https_endpoint"

  project = var.project
  region  = var.region

  cloud_run_max_instances                 = var.cloud_run_max_instances
  dragondrop_https_trigger_container_path = var.dragondrop_https_trigger_container_path
  dragondrop_engine_cloud_run_job_name    = var.dragondrop_engine_cloud_run_job_name
  https_trigger_cloud_run_service_name    = var.https_trigger_cloud_run_service_name
  service_account_email                   = google_service_account.cloud_run_service_account.email
}
