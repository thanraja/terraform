provider "consul" {
    scheme = "http"
    address = "${var.consul_server}:${var.consul_port}"
    datacenter = var.datacenter
}

data "consul_keys" "networking" {
    key {
        path = "networking/configuration/globo-primary/info"
        name = "networking"

    }
 }
        # path = "networking/state/globo-primary/m5"

output "networking" {
    value = data.consul_keys.networking.var.networking
}
output "cidr" {
    value = jsondecode(data.consul_keys.networking.var.networking)["cidr_block"]
}

data "template_file" "subnets" {
    count = 2
    template = "$${cidrsubnet(cidr,8,count)}"

    vars = {
        count = count.index
        cidr = "10.0.0.0/16"
    }
}
output "subnets" {
    value = data.template_file.subnets[*].rendered
}

data "http" "myip" {
    url = "http://ifconfig.me/all.json"
}
output "ip" {
    value = data.http.myip.body
}
