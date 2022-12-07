resource "google_secret_manager_secret" "secret" {
  project = var.project
  secret_id = "DRAGONDROP_${var.secret_id}"

  labels = {
    label = "dragondrop-engine"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  project = var.project
  secret_id = google_secret_manager_secret.secret.secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${var.dragondrop_compute_service_account}"
  depends_on = [google_secret_manager_secret.secret]
}
