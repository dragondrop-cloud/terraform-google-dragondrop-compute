resource "google_secret_manager_secret" "secret" {
  project   = var.project_name
  secret_id = "DRAGONDROP_${var.secret_id}"

  labels = {
    label = "dragondrop-engine"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret      = google_secret_manager_secret.secret.name
  secret_data = "placeholder-value-for-initial-provisioning"
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  project    = var.project_name
  secret_id  = google_secret_manager_secret.secret.secret_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${var.compute_service_account_email}"
  depends_on = [google_secret_manager_secret.secret]
}
