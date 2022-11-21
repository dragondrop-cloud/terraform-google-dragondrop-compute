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

resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project
  role    = google_project_iam_custom_role.dragondrop-https-trigger-role.id
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

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
               image = "us-east4-docker.pkg.dev/dragondrop-dev/dragondrop-https-triggers/cloud-run-service:latest"

               env {
                 name  = "JOB_NAME"
                 value = var.dragondrop_engine_cloud_run_job_name
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
        percent = 100
        latest_revision = true
    }
}

# Allow external IP addresses to invoke the HTTPS trigger service
resource "google_cloud_run_service_iam_member" "accessible_trigger" {
  location = google_cloud_run_service.https_job_trigger.location
  project = google_cloud_run_service.https_job_trigger.project
  service = google_cloud_run_service.https_job_trigger.name

  role = "roles/run.invoker"
  member = "allUsers"
}
