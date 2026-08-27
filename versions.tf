terraform {
  required_version = ">= 1.15.0"

  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.1"
    }
  }
}
