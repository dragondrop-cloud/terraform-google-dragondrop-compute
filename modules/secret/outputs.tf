output "secret_id" {
  description = "Secret id of the new secret."
  value       = google_secret_manager_secret.secret.secret_id
}
