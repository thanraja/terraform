locals {
    project = data.google_client_config.current.project
    region = var.region
    bucket_name = "gs://${local.project}-mybucket"

    create_command =<<-EOF
        gsutil mb \
          -l ${local.region} \
          -p ${local.project} \
          ${local.bucket_name}
    EOF

    destroy_command =<<-EOF
        gsutil -m rm -rf  \
          ${local.bucket_name}

    EOF
    
}

resource "null_resource" "mybucket" {
    provisioner "local-exec" {
        when = create
        command = local.create_command
    }

    provisioner "local-exec" {
        when = destroy
        command = local.destroy_command
    
    }

}

data "google_client_config" "current" {}

output "create_command" {
    value = local.create_command
}

output "destroy_command" {
    value = local.destroy_command
}