provider "consul" {
    address = "${var.consul_server}:${var.consul_port}"
    datacenter = "dc1"
}

data "consul_keys" "networking" {
    key {
        name = "networking"
        path = terraform.workspace =="default"? "networking/configuration/globo-primary/info" : "networking/configuration/globo-primary/${terraform.workspace}/info"
    }
}
output "subnet_count" {
    value = jsondecode(data.consul_keys.networking.var.networking).subnet_count
}
data "google_client_config" "current" {}

resource "random_integer" "myint"{
    min = 10000
    max = 99999
}

resource "google_storage_bucket" "b1" {
    name = "${data.google_client_config.current.project}-${terraform.workspace}-${random_integer.myint.result}"
    
}