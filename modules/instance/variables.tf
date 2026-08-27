variable "instance_name" {
  description = "Name of the Civo instance"
  type        = string
}

variable "ssh_key_id" {
  description = "Civo SSH key ID"
  type        = string
}


variable "instance_type" {
  description = "Civo instance size"
  type        = string
  default     = "g3.small"
}

variable "network_id" {
  description = "Civo network ID"
  type        = string
}

variable "firewall_id" {
  description = "Civo firewall ID"
  type        = string
}

variable "disk_image" {
  description = "Civo disk image UUID"
  type        = string
}
