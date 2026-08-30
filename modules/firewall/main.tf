resource "civo_firewall" "this" {
  name = "${var.firewall_name}-${terraform.workspace}"
  network_id = var.network_id
}
