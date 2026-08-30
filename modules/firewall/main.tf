resource "civo_firewall" "this" {
  label = "${var.firewall_name}-${terraform.workspace}"
  network_id = var.network_id
}
