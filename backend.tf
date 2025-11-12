terraform {
  backend "s3" {
    bucket = "terraform-remote-state-ahmad"
    key    = "global/s3/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

