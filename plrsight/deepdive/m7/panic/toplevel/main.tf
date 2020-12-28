module "out" {
    source = "./module"
    
}

output "name" {
    value = module.out.myname
}