output "api_url" {
  value       = google_cloud_run_service.https_job_trigger.status[0].url
  description = "The url where requests for the https dragondrop trigger hosted on GCP Cloud Run can be sent."
}
