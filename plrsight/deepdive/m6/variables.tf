variable "consul_server" {
    type = string
    default = "127.0.0.1"
}

variable "consul_port" {
    type = number
    default = 8500
}
variable "datacenter" {
    type = string
    default = "dc1"
}
