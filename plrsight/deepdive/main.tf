terraform {
    required_version = ">=0.12"
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>3.51.0"
        }
    }
}
provider "google" {
    # region = "us-east1"
}

data "google_compute_zones" "available" {
    region = "us-central1"
}

resource "google_storage_bucket" "b2" {
    name = "raj-24343-34343"
    location = "us-east1"
}

output "zones" {
    value = data.google_compute_zones.available
}