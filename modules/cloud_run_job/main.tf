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

module "providers" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "PROVIDERS"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "terraform_version" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "TERRAFORMVERSION"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "relative_directory_markdown" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "RELATIVEDIRECTORYMARKDOWN"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "workspace_to_directory" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "WORKSPACETODIRECTORY"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "migration_history_storage" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "MIGRATIONHISTORYSTORAGE"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "vcs_token" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSTOKEN"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "vcs_user" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSUSER"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "vcs_repo" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSREPO"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "vcs_system" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSSYSTEM"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "vcs_base_branch" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "VCSBASEBRANCH"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "state_backend" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "STATEBACKEND"
  compute_service_account_email = var.dragondrop_compute_service_account_email
}

module "terraform_cloud_organization" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "TERRAFORMCLOUDORGANIZATION"
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

module "job_id" {
  source = "../secret"

  project_name                  = var.project
  project_number                = data.google_project.project.number
  secret_id                     = "JOBID"
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
          name = module.providers.secret_id
          value_source {
            secret_key_ref {
              secret  = module.providers.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.terraform_version.secret_id
          value_source {
            secret_key_ref {
              secret  = module.terraform_version.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.relative_directory_markdown.secret_id
          value_source {
            secret_key_ref {
              secret  = module.relative_directory_markdown.secret_id
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
          name = module.migration_history_storage.secret_id
          value_source {
            secret_key_ref {
              secret  = module.migration_history_storage.secret_id
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
          name = module.vcs_user.secret_id
          value_source {
            secret_key_ref {
              secret  = module.vcs_user.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.vcs_repo.secret_id
          value_source {
            secret_key_ref {
              secret  = module.vcs_repo.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.vcs_system.secret_id
          value_source {
            secret_key_ref {
              secret  = module.vcs_system.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.vcs_base_branch.secret_id
          value_source {
            secret_key_ref {
              secret  = module.vcs_base_branch.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.state_backend.secret_id
          value_source {
            secret_key_ref {
              secret  = module.state_backend.secret_id
              version = "latest"
            }
          }
        }

        env {
          name = module.terraform_cloud_organization.secret_id
          value_source {
            secret_key_ref {
              secret  = module.terraform_cloud_organization.secret_id
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

        env {
          name = module.job_id.secret_id
          value_source {
            secret_key_ref {
              secret  = module.job_id.secret_id
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
    module.division_to_provider, module.division_cloud_credentials, module.providers,
    module.terraform_version, module.relative_directory_markdown, module.workspace_to_directory,
    module.migration_history_storage, module.vcs_token, module.vcs_user, module.vcs_repo,
    module.vcs_system, module.vcs_base_branch, module.state_backend, module.terraform_cloud_organization,
    module.terraform_cloud_token, module.job_token, module.job_id
  ]
}

