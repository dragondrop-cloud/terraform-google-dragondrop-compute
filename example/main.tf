module "dragondrop_compute" {
  source  = "app.terraform.io/dragondrop-cloud/dragondrop-compute/google"
  version = "0.2.0"

  project = "my-gcp-project"
  region  = "us-east4"

  cloud_run_max_instances              = "2"
  https_trigger_cloud_run_service_name = "dragondrop-https-trigger"
  dragondrop_engine_cloud_run_job_name = "dragondrop-job-name"
  dragondrop_engine_container_path     = "us-east4-docker.pkg.dev/dragondrop-prod/dragondrop-engine/engine@latest"
  service_account_name                 = "dragondrop-compute"
}
