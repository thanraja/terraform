

provider "consul" {
    address = "127.0.0.1:8500"
    datacenter = "dc1"
}

resource "consul_keys" "networking" {
    key {
        path = "networking/configuration/"
        value = ""
    }
    key {
        path = "networking/state/"
        value = ""
    }
}

resource "consul_keys" "applications" {
    key {
        path = "applications/configuration"
        value = ""
    }
    key {
        path = "applications/state"
        value = ""
    }
}

resource "consul_acl_policy" "networking" {
    name = "networking"
    
    rules = <<-RULE
        key_prefix "networking" {
            policy = "write"
        }

        session_prefix "" {
            policy = "write"
        }
    RULE
}

resource "consul_acl_policy" "applications" {
    name = "applications"

    rules = <<-RULE
        key_prefix "applications" {
            policy = "write"
        }

        key_prefix "networking/state" {
            policy = "read"
        }

        session_prefix "" {
            policy = "write"
        }

    RULE
}

resource "consul_acl_token" "mary" {
    description = "Token for Mary"
    policies = [consul_acl_policy.networking.name]
}

resource "consul_acl_token" "sally" {
    policies = [consul_acl_policy.applications.name]
    description = "Token for Sally : applications "
}

output "mary_token_networking" {
    value = consul_acl_token.mary.id
}

output "sally_token_applications" {
    value = consul_acl_token.sally.id
}
#  Secret Consul : 66830895-d346-c456-42c8-10ba45bf942a
# Mary : 851b417b-35cc-2bda-28af-6e587e0649b2
# Sally : 18d42a64-a2f9-a3cb-0af1-df942bf380cd

# terraform init -backend-config="path=networking/state/globo-primary/m6"
#  export CONSUL_HTTP_TOKEN=66830895-d346-c456-42c8-10ba45bf942a

consul kv put networking/configuration/globo-primary/dev/info @dev-net.json
consul kv put networking/configuration/globo-primary/qa/info @qa-net.json
consul kv put networking/configuration/globo-primary/prod/info @prod-net.json
