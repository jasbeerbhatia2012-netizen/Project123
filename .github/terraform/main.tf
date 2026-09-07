terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  type        = string
  description = "The Google Cloud Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Free-tier eligible region (e.g., us-central1, us-east1, us-west1)"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "free_tier_bucket" {
  name          = "devops-free-bucket-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = "STANDARD"

  # Prevents public access to secure the bucket
  public_access_prevention = "enforced"

  # Enforce uniform bucket-level access
  uniform_bucket_level_access = true

  # Ensure soft-delete is set to 0 for a quick cleanup testing environment
  soft_delete_policy {
    retention_duration_seconds = 0
  }
}

output "bucket_name" {
  value       = google_storage_bucket.free_tier_bucket.name
  description = "The name of the created GCS bucket"
}
