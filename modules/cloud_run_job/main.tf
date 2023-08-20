# Enable the Secret Manager API
resource "google_project_service" "secret_manager_api" {
  service            = "secretmanager.googleapis.com"
  project            = var.project
  disable_on_destroy = false
}

data "google_project" "project" {
}

// Cloud Run Job Service Account
resource "google_service_account" "cloud_run_job_service_account" {
  account_id  = "cloud-concierge-runner"
  description = "Service accounts used by managed Cloud Run Jobs that execute the cloud-concierge container."
  project     = var.project
}

resource "google_project_iam_member" "cloud_environment_reader" {
  project = var.project
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.cloud_run_job_service_account.email}"
}

resource "google_storage_bucket_iam_member" "bucket_1" {
  count  = var.gcs_state_bucket != "None" ? 1 : 0
  bucket = var.gcs_state_bucket
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloud_run_job_service_account.email}"
}

# Create the required environment variables
module "vcs_token" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSTOKEN"
  compute_service_account_email = google_service_account.cloud_run_job_service_account.email
}

module "terraform_cloud_token" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "TERRAFORMCLOUDTOKEN"
  compute_service_account_email = google_service_account.cloud_run_job_service_account.email
}

# Defining the secrets needed for Environment variables of the Cloud Run Job
resource "google_cloud_run_v2_job" "dragondrop-engine" {
  provider     = google
  name         = var.cloud_run_job_name
  location     = var.region
  project      = var.project
  launch_stage = "BETA"

  template {
    task_count = 1

    template {
      service_account = google_service_account.cloud_run_job_service_account.email

      containers {
        image = var.cloud_concierge_container_path

        env {
          name = module.vcs_token.secret_id
          value_source {
            secret_key_ref {
              secret  = module.vcs_token.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.terraform_cloud_token.secret_id
          value_source {
            secret_key_ref {
              secret  = module.terraform_cloud_token.secret_id
              version = "latest"
            }
          }
        }

        resources {
          limits = {
            memory = "8Gi"
            cpu    = "4"
          }
        }
      }
    }
  }
  depends_on = [
    module.vcs_token,
    module.terraform_cloud_token
  ]
}
