data_dir  = "/var/hcp/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "dc1"

# Enable the server
server {
  enabled          = true
}

client {
  enabled = true
  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}

consul {
  address = "127.0.0.1:8500"
  #token = "${consul_token}"
}
