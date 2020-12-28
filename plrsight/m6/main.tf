variable "network_address_space" {
    type = string
    default = "10.1.0.0/16"
    description = "(optional) describe your variable"
}
locals {
    a_map = {
        k = "value"
        n = 5.3434
    }
}