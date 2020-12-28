provider "consul" {
    address = "${var.consul_server}:${var.consul_port}"
    datacenter = "dc1"
}

data "terraform_remote_state" "networking" {
    backend = "consul"
    config = {
            path = terraform.workspace == "default" ? "networking/state/globo-primary/m6": "networking/state/globo-primary/m6-env:${terraform.workspace}"
            address = "${var.consul_server}:${var.consul_port}"
            datacenter = "dc1"

    }
}
output "subnet_count" {
    value = data.terraform_remote_state.networking.outputs.subnet_count
}
