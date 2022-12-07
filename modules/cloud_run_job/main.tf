module "division_to_provider" {
  source = "../secret"

  project = var.project
  secret_id = "DIVISIONTOPROVIDER"
  dragondrop_compute_service_account = var.dragondrop_compute_service_account
}

## Defining the secrets needed for Environment variables of the Cloud Run Job
resource "google_cloud_run_service_v2_job" "dragondrop-engine" {
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
            value_from {
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

