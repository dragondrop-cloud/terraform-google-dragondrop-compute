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

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "DIVISIONTOPROVIDER"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "division_cloud_credentials" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "DIVISIONCLOUDCREDENTIALS"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "workspace_to_directory" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "WORKSPACETODIRECTORY"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "vcs_token" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSTOKEN"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "terraform_cloud_token" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "TERRAFORMCLOUDTOKEN"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "job_token" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "JOBTOKEN"
  compute_service_account_email = var.dragondrop_compute_service_account_email
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

        env {
          name = module.division_cloud_credentials.secret_id
          value_source {
            secret_key_ref {
              secret  = module.division_cloud_credentials.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.workspace_to_directory.secret_id
          value_source {
            secret_key_ref {
              secret  = module.workspace_to_directory.secret_id
              version = "latest"
            }
          }
        }

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

        env {
          name = module.job_token.secret_id
          value_source {
            secret_key_ref {
              secret  = module.job_token.secret_id
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
    module.division_to_provider, module.division_cloud_credentials,
    module.workspace_to_directory,
    module.vcs_token,
    module.terraform_cloud_token, module.job_token
  ]
}

