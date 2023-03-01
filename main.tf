variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}
variable "credentials_file" {}
variable "bucket_name" {
  default = "pacforce-terraform-state-test"
}
variable "terraform_service_account" {}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
}

resource "google_storage_bucket" "terraform_state_bucket" {
  name                     = var.bucket_name
  project                  = var.project_id
  location                 = "US-CENTRAL1"
  force_destroy            = false
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = var.bucket_name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.terraform_service_account}"
}