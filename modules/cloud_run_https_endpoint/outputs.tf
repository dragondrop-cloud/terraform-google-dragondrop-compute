output "https_trigger_url" {
  value       = google_cloud_run_service.https_job_trigger.status[0].url
  description = "The url where requests to the https dragondrop trigger hosted on GCP Cloud Run can be sent."
}
