resource "civo_firewall" "this" {
  name       = var.firewall_name
  network_id = var.network_id
}
