
seal "transit" {
   address            = "http://${lan_ip}:8200"
   # token is read from VAULT_TOKEN env
   # token              = ""
   disable_renewal    = "false"

   // Key configuration
   key_name           = "unseal_key"
   mount_path         = "transit/"
}