variable "input" {
    type = string
    description = "(optional) describe your variable"
    default = "Rajesh"
}

output "out" {
    value = format("Hello %s","${var.input}")
}
data "google_client_config" "current" {}

output "config" {
    value=data.google_client_config.current
}
resource "google_storage_bucket" "b1" {
    force_destroy=true
    name="${data.google_client_config.current.project}-terraformstate"
    location = "us-east1"
    versioning {
        enabled = true
    }
}

output "b2" {
    value = google_storage_bucket.b1
}


# terraform {
#     backend "gcs" {
#         bucket = "proj-demo-120-terraformstate"

#     }
# }