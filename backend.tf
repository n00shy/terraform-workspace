terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"

    endpoints = {
      s3 = "https://objectstore.nyc1.civo.com"
    }

    region = "nyc1"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    use_path_style              = true

    skip_s3_checksum = true
  }
}
