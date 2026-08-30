resource "civo_network" "this2" {
  label = "${var.network_name}-${terraform.workspace}"
}
