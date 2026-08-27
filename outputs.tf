output "network_id" {
  description = "ID of the Civo network"
  value       = module.network.network_id
}

output "firewall_id" {
  description = "Created Civo firewall ID"
  value       = module.firewall.firewall_id
}

output "instance_ids" {
  description = "IDs of the Civo instances"
  value       = module.instance[*].instance_id
}

output "instance_public_ips" {
  description = "Public IPs of the Civo instances"
  value       = module.instance[*].public_ip
}
