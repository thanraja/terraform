variable "region" {
    type = string
    default = "us-east1"
    description = "(optional) describe your variable"
}
variable "zone" {
    type = string
    default = "us-east1-b"
    description = "(optional) describe your variable"
}
variable "tags" {
    type = list
    default = ["http"]
    description = "(optional) describe your variable"
}

provider "google" {
    region = var.region
    zone = var.zone
}

data "google_compute_image" "myimage" {
    project = "debian-cloud"
    family = "debian-10"

}

variable "instanceName" {
    type = string
    default = "jenkins"
}

resource "google_compute_disk" "mydisk" {
    size = "10"
    image = data.google_compute_image.myimage.self_link
    name = var.instanceName
    type = "pd-ssd"

}
variable "network_name" {
    type = string
    default = "default"
    description = "(optional) describe your variable"
}

# resource "google_compute_network" "mynetwork" {
#     name = var.network_name
#     auto_create_subnetworks = false
# }
# resource "google_compute_subnetwork" "mysubnet" {
#     name = var.network_name
#     network = google_compute_network.mynetwork.self_link
#     region = var.region
#     ip_cidr_range = "10.0.0.0/24"
# }

resource "google_compute_firewall" "allow_http" {
    name = "allow-http"
    network = var.network_name
    source_ranges = ["0.0.0.0/0"]
    target_tags = var.tags
    allow {
        protocol = "tcp"
        ports = [80,8080]
    }

}

output "jenkins_url" {
    value = "http://${google_compute_instance.myinstance.network_interface[0].access_config[0].nat_ip}:8080/"
}

resource "google_compute_instance" "myinstance" {
    tags = var.tags
    name = var.instanceName
    machine_type="f1-micro"
    metadata = {
        enable-oslogin = true
    }
        metadata_startup_script=<<-EOF
            sudo apt-get update
            sudo apt-get -y install git-all default-jre
            sudo apt-get -y install default-jdk 
            java -version
            cd /tmp
            curl -LO http://mirrors.jenkins.io/war-stable/latest/jenkins.war
            java -jar jenkins.war >/tmp/jenkins.log &
        EOF
    

    network_interface {
        network = var.network_name
        # subnetwork = google_compute_subnetwork.mysubnet.self_link
        access_config {}
    }

 boot_disk {
     source = google_compute_disk.mydisk.self_link
     auto_delete = false
 }
}