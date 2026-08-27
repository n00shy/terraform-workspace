output "instance_id" {
  description = "Civo instance ID"
  value       = civo_instance.this.id
}

output "public_ip" {
  description = "Public IP address"
  value       = civo_instance.this.public_ip
}
