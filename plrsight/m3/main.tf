data "google_compute_image" "default" {
    family = "debian-10"
    project = "debian-cloud"
}

data "google_compute_network" "default" {
  name = "default"
}
output "network" {
    value = data.google_compute_network.default
}
