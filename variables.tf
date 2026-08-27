variable "ssh_key_id" {
  description = "Civo SSH key ID"
  type        = string
}

variable "region" {
  description = "Civo region"
  type        = string
  default     = "nyc1"
}

variable "disk_image" {
  description = "Civo disk image UUID"
  type        = string
}
