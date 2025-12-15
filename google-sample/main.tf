# Configure Terraform and required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Backend configuration for GitLab managed state
  backend "http" {
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# ----------------------------------------------------
# 1. Cloud Function (2nd Gen) Resource
# ----------------------------------------------------
# Uses source-based deployment from Cloud Storage bucket
resource "google_cloudfunctions2_function" "hello_world_function" {
  name     = var.function_name
  project  = var.project_id
  location = var.region

  # Build configuration for source-based deployment
  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point

    source {
      storage_source {
        bucket = var.source_bucket
        object = var.source_archive_object
      }
    }
  }

  # Service configuration
  service_config {
    # Set the service account email
    service_account_email = var.runtime_service_account

    # Memory and concurrency settings
    available_memory                 = var.available_memory
    max_instance_count               = var.max_instance_count
    max_instance_request_concurrency = var.max_instance_request_concurrency
    timeout_seconds                  = var.timeout_seconds
  }
}

# ----------------------------------------------------
# 2. IAM Policy for domain-based access
# ----------------------------------------------------
# Grants 'domain:mia-platform.eu' the permission to invoke the function
resource "google_cloud_run_service_iam_member" "domain_access" {
  project  = google_cloudfunctions2_function.hello_world_function.project
  location = google_cloudfunctions2_function.hello_world_function.location
  service  = google_cloudfunctions2_function.hello_world_function.name

  role   = "roles/run.invoker"
  member = "domain:mia-platform.eu"
}

# ----------------------------------------------------
# 3. Output the deployed URL
# ----------------------------------------------------
output "function_url" {
  description = "The URL of the deployed Cloud Function (2nd Gen)."
  value       = google_cloudfunctions2_function.hello_world_function.url
}
