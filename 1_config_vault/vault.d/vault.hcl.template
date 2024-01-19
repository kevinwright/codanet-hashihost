ui = true
cluster_addr  = "https://${lan_ip}:8201"
api_addr      = "https://${lan_ip}:8200"
disable_mlock = true

storage "raft" {
  path = "/var/hcp/vault/data"
  node_id = "${hostname}"
  retry_join {
    auto_join = "provider=mdns v4=true v6=false service=_hashicorp_vault_server._tcp"
  }
}

listener "tcp" {
  address         = "0.0.0.0:8200"
  cluster_address = "${lan_ip}:8201"
  tls_disable     = true
}
