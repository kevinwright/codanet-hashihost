terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.1"
    }
  }
}

data "external" "lan_net" {
  program = ["bash", "${path.module}/tf_extern_scripts/lan_network.sh"]
}

data "external" "avahi" {
  program = ["bash", "${path.module}/tf_extern_scripts/avahi_scan.sh"]
}

locals {
  lan_ip = data.external.lan_net.result.ip
  lan_subnet = data.external.lan_net.result.subnet
  retry_join = jsondecode(data.external.avahi.result.other_ips)
  server_count = length(local.retry_join) + 1
}

resource "local_file" "config_files" {
  for_each = fileset("${path.module}/config_files", "*/*.tftpl")
  content = templatefile(
    "${path.module}/config_files/${each.key}",
    {
      lan_ip = local.lan_ip,
      retry_join = jsonencode(local.retry_join),
      server_count = local.server_count,
      consul_token = var.consul_token,
      gossip_key = var.gossip_key
    }
  )
  filename = "/etc/${trimsuffix("${each.key}", ".tftpl")}"
}

resource "terraform_data" "start_services" {
  for_each = toset(["consul", "consul-template", "nomad", "vault"])
  provisioner "local-exec" {
    command = "systemctl enable ${each.key}.service"
  }
    provisioner "local-exec" {
    command = "systemctl start ${each.key}.service"
  }
}