terraform {
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

resource "terraform_data" "config_files" {
  for_each = fileset("${path.module}/config_files", "*/*.tftpl")
  provisioner "file" {
    content = templatefile(
      each.key,
      {
        lan_ip = local.lan_ip,
        retry_join = local.retry_join,
        server_count = local.server_count,
        consul_token = var.consul_token
      }
    )
    destination = "/tmp/test/etc/${trimsuffix("each.key", ".tftpl")}"
  }
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