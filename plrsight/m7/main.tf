locals {
    env = terraform.workspace
    bucket_name = "${local.env}-${random_integer.rand.result}"
}

variable "count_buckets" {
    type = map(number)
    default = {
        dev = 1
        prod = 5
    }
}

resource "random_integer" "rand" {
    min = 189800
    max = 999999
}

variable "versioning" {
    type = map(bool)
    default = {
        dev = false
        prod = true
    }
}


resource "google_storage_bucket" "bucket" {
    count = var.count_buckets[terraform.workspace]
    name = "${local.bucket_name}-${count.index+1}"
    versioning {
        enabled = var.versioning[terraform.workspace]
    }
    lifecycle_rule  {
        condition {
            age = 3
        }
        action {
            type = "Delete"
        }
    }
}
data "template_file" "cidr" {
    count = 8
    template = "$${cidrsubnet(cidr,8,count)}"

    vars = {
        cidr= "10.0.0.0/16"
        count = count.index
    }
}

output "cidrsubnets" {
    value = data.template_file.cidr[*].rendered
}

output "slice" {
    value = "${slice(data.template_file.cidr[*].rendered,0,2)}"
}
