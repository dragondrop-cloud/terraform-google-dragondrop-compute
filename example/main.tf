module "dragondrop_compute" {
  source  = "app.terraform.io/dragondrop-cloud/dragondrop-compute/google"
  version = "0.4.3"

  project = "my-gcp-project"
  region  = "us-east4"

  cloud_run_max_instances              = "2"
  https_trigger_cloud_run_service_name = "dragondrop-https-trigger"
  dragondrop_engine_cloud_run_job_name = "dragondrop-job-name"
  service_account_name                 = "dragondrop-compute"
}
