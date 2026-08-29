module "network" {
  source = "./modules/network"

  network_name = "devops-${terraform.workspace}-network"
}

module "firewall" {
  source = "./modules/firewall"

  firewall_name = "devops-${terraform.workspace}-firewall"
  network_id    = module.network.network_id
}

module "instance" {

  count  = 2
  source = "./modules/instance"

  instance_name = "cloudops-${terraform.workspace}-${count.index + 1}"
  instance_type = "g3.small"

  network_id  = module.network.network_id
  firewall_id = module.firewall.firewall_id
  ssh_key_id  = var.ssh_key_id
  disk_image  = var.disk_image

}
