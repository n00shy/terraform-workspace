output "firewall_id" {
  description = "ID of the Civo firewall"
  value       = civo_firewall.this.id
}
