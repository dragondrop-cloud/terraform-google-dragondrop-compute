output "https_trigger_url" {
  value       = module.cloud_run_https_endpoint.https_trigger_url
  description = "The url where requests to the https dragondrop trigger hosted on GCP Cloud Run can be sent."
}
