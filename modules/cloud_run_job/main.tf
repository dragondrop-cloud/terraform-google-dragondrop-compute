# Enable the Secret Manager API
resource "google_project_service" "secret_manager_api" {
  service            = "secretmanager.googleapis.com"
  project            = var.project
  disable_on_destroy = false
}

data "google_project" "project" {
}

# Create the required environment variables
module "division_to_provider" {
  source = "../secret"

  project_name                       = var.project
  project_number                     = data.google_project.project.number
  secret_id                          = "DIVISIONTOPROVIDER"
  compute_service_account_email      = var.dragondrop_compute_service_account_email
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
      service_account = var.dragondrop_compute_service_account_email

      containers {
        image = var.dragondrop_engine_container_path

        env {
          name = module.division_to_provider.secret_id
          value_source {
            secret_key_ref {
              secret  = module.division_to_provider.secret_id
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
}

