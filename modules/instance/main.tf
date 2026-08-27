resource "civo_instance" "this" {
  hostname     = var.instance_name
  size         = var.instance_type
  initial_user = "civo"
  tags         = ["terraform"]

  network_id  = var.network_id
  firewall_id = var.firewall_id
  sshkey_id   = var.ssh_key_id

  disk_image = var.disk_image

 
}
