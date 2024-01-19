data_dir = "/var/hcp/consul/data"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "${lan_ip}"
retry_join = "provider=mdns v4=true v6=false service=_hashicorp_consul_server._tcp"

#encrypt = "${gossip_key}"

log_level = "INFO"

server = true

ui_config {
  enabled = true
}

service {
    name = "consul"
}

connect {
  enabled = true
}

ports {
  grpc = 8502
}