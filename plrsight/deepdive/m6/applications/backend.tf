terraform {
    backend "consul" {
        address = "127.0.0.1:8500"
        scheme = "http"
    }
}

#  export CONSUL_HTTP_TOKEN=18d42a64-a2f9-a3cb-0af1-df942bf380cd
# terraform init -backend-config="path=applications/state/globo-primary/m6"
# Sally : 18d42a64-a2f9-a3cb-0af1-df942bf380cd

