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

resource "google_secret_manager_secret_iam_member" "secret_access" {
  project    = var.project_name
  secret_id  = google_secret_manager_secret.secret.secret_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.secret]
}
