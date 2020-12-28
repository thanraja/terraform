
provider "google" {
  project = var.projectid
  region  = var.region
  zone    = var.zone
}
data "google_client_config" "current" {}
output "config" {
  value = data.google_client_config.current
}
resource "random_integer" "myint" {
    min = 1200000
    max = 1299999
}
output "zmyrandomint" {
    value = random_integer.myint.result
}

locals {
  unique = "${data.google_client_config.current.project}-${lower(data.google_client_config.current.region)}"
}



output "b2" {
  value = google_storage_bucket.b2
}

resource "google_storage_bucket" "b2" {

  count    = 2
  name     = "${local.unique}-${count.index + 1}"
  location = var.region
}
locals {
  myset = []
  mymap = {
    k = "val"
  }
}

output "list" {
  value = local.myset
}
output "set" {
  value = toset(local.myset)
}

variable "total" {
  type    = number
  default = 0
}

locals {
  num = var.total > 0 ? var.total : 0
}
resource "google_storage_bucket" "bucket" {
  count    = local.num
  location = var.region
  name     = "${local.unique}-${count.index + 1}"
}

locals {
  t = formatlist("Hi-%s", [])
}


resource "google_storage_bucket" "b" {
  for_each = toset(local.t)
  location = var.region
  name     = "${local.unique}-${lower(each.value)}"
}

output "splat_bucket_names" {
  value = google_storage_bucket.b2[*].name
}

locals {
  a_string  = "Hello"
  a_number  = 3.55434
  a_boolean = false
  a_list = [
    "Rajesh",
    3.4,
    "Hello"
  ]
  a_map = {
    key = "myvalue",
    y   = 2.3
  }
}

output "datatypes" {
    value = "${local.a_string},${local.a_number},${local.a_boolean}"
}
output "alist" {
    value = "${local.a_list}"
}

output "amap" {
    value = "${local.a_map["key"]}"
}
output "home_phone" {
    value = local.a_person.phone.home
}
locals {
    a_person = {
        name = "Rajesh",
        phone = {
            home = 23923232
            office = 33434343

        }
    }
}
output "arithmetic" {
    value = "${local.add},${local.sub},${local.mult},${local.div}"
}
output "logical" {
    value = "${local.and},${local.or}"
}
locals {
# arithmetic operators
add = 3 + 2
sub = 3 -2
mult = 3 * 2
div = 3 / 3

# logical operators
and = true && false
or = true || false
# Comparators
gt = 2 > 1
gte = 3>=3
lt = 2<4
lte = 2<=2
eq = "Rajesh" == local.a_person.name
neq = "Rajesh" != "rajesh"

}
output "comparators" {
    value = "${local.gt},${local.gte},${local.lt},${local.lte},${local.eq},${local.neq}"
}

# functions 
locals {
    ts = timestamp()
    month = formatdate("MMMM",timestamp())
    day = formatdate("DD",local.ts)
    tomorrow = formatdate("YYYYMMDD HH:mm ZZZ",timeadd(local.ts,"24h"))
    # string functions
    lower = lower ("RAJ")
    upper = upper("rajesh")
    trimspace = trimspace (" Rajesh ")

}
output "string_function" {
    value = "${local.lower},${local.upper},${local.trimspace}"
}
output "functions" {
    value = "${local.ts},${local.month},${local.day},${local.tomorrow}"
}

locals {
    # iterations
    my_list = ["one","two","three"]
    upper_list = [for i in local.my_list: upper(i)]
    my_map = {for i in local.my_list: i => upper(i) }
# filters
numbers = [0,1,2,3,4,5,6]
evens = [for i in local.numbers : i if i%2 == 0]
}
output "evens" {
    value = local.evens
}
output "heredoc" {
    value =<<-EOF
        This is called `heredoc`
        multiline string representation by using << representation.
    EOF
}
output "directive" {
    value =<<-EOF
    This is a heredoc with directives
    %{ if local.a_person.name == "" }
    Sorry Name is unknown
    %{ else }
    Welcome ${local.a_person.name}
    %{endif}
    EOF
}
output "iterated" {
    value =<<-EOF
        This is iterated heredoc
        %{for i in local.evens}
        ${i} is even
        %{endfor}
    EOF
}

output "upper_list" {
    value = local.upper_list
}
output "my_map" {
    value = local.my_map
}

module "hello" {
    source = "./modules"
    input = "Banu"
}

output "welcome" {
    value = module.hello.out
}
output "zbucket" {
    value = module.hello.b2
}

