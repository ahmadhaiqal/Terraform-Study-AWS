
terraform {
  # backend "s3" {
  #   bucket = "terraform-state-ahmad"
  #   key    = "aws/terraform.tfstate"
  #   region = "ap-southeast-1"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "first_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "ahmad-tf-module-bucket-1"
  tags = {
    Environment = "Dev"
    Owner       = "Ahmad"
  }
}

module "second_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "ahmad-tf-module-bucket-2"
  tags = {
    Environment = "Staging"
    Owner       = "Ahmad"
  }
}

