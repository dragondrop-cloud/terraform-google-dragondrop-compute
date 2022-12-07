# Enable the Secret Manager API
resource "google_project_service" "secret_manager_api" {
  service = "secretmanager.googleapis.com"
  project = var.project
  disable_on_destroy = false
}

# Create the required environment
module "division_to_provider" {
  source = "../secret"

  project = var.project
  secret_id = "DIVISIONTOPROVIDER"
  dragondrop_compute_service_account = var.dragondrop_compute_service_account_email
}

## Defining the secrets needed for Environment variables of the Cloud Run Job
resource "google_cloud_run_v2_job" "dragondrop-engine" {
   provider = google-beta
   name = var.cloud_run_job_name
   location = var.region
   project = var.project

   template {
      template {
        service_account_name = "serviceAccount:${var.dragondrop_compute_service_account_email}"

        containers {
          // TODO: change this to a variable name etc.
          image = "us-docker.pkg.dev/cloudrun/container/hello"

          env {
            name = module.division_to_provider.secret_id
            value_source {
              secret_key_ref {
                name = module.division_to_provider.secret_id
                key  = "latest"
              }
            }
          }

          resources {
            requests = {
              memory = "1600M"
              cpu = "4000m"
            }
          }
        }
      }
    }
}

