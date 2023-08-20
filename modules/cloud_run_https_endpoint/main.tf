// Cloud Run Service Account
resource "google_service_account" "cloud_run_service_account" {
  account_id  = "dd-cloud-run-https-trigger"
  description = "Service accounts used by the dragondrop.cloud Cloud Run service to programmatically evoke cloud-concierge instances."
  project     = var.project
}

resource "google_project_iam_custom_role" "dragondrop-https-trigger-role" {
  project     = var.project
  role_id     = "dragondropHTTPSTriggerRole"
  title       = "dragondrop HTTPS Trigger Role"
  description = "Role for the dragondrop https trigger to update and invoke Cloud Run Jobs."
  permissions = ["run.executions.get", "run.jobs.get", "run.jobs.run", "run.jobs.update"]
}

data "google_iam_policy" "admin" {
  binding {
    role = google_project_iam_custom_role.dragondrop-https-trigger-role.id
    members = [
      "serviceAccount:${google_service_account.cloud_run_service_account.email}"
    ]
  }
}

resource "google_cloud_run_v2_job_iam_policy" "policy" {
  project     = var.project
  location    = var.region
  name        = var.cloud_concierge_cloud_run_job_name
  policy_data = data.google_iam_policy.admin.policy_data
}

# Creating the actual cloud run service resource
resource "google_cloud_run_service" "https_job_trigger" {
  name                       = var.https_trigger_cloud_run_service_name
  location                   = var.region
  project                    = var.project
  autogenerate_revision_name = true

  template {

    spec {

      service_account_name = google_service_account.cloud_run_service_account.email

      containers {
        # This image's is open sourced and available for inspection at:
        # https://github.com/dragondrop-cloud/cloud-run-job-http-trigger
        image = var.dragondrop_https_trigger_container_path

        env {
          name  = "JOB_NAME"
          value = var.cloud_concierge_cloud_run_job_name
        }

        env {
          name  = "JOB_REGION"
          value = var.region
        }

        ports {
          container_port = 5000
        }

        resources {
          // The memory requirements for the hosted image are very small.
          // these resource specifications should be more than sufficient.
          requests = {
            memory = "400M"
            cpu    = "1000m"
          }

          limits = {
            memory = "1000M"
            cpu    = "2000m"
          }
        }

      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = var.cloud_run_max_instances
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Allow external IP addresses to invoke the HTTPS trigger service
resource "google_cloud_run_service_iam_member" "accessible_trigger" {
  location = google_cloud_run_service.https_job_trigger.location
  project  = google_cloud_run_service.https_job_trigger.project
  service  = google_cloud_run_service.https_job_trigger.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
