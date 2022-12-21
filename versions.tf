terraform {
  required_version = ">=1.0.0"

  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=4.46.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">=4.45.0"
    }
  }
}
