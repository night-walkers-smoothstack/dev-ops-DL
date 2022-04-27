terraform {
  backend "s3" {
    bucket = "alinefinacialterraformstatedl"
    key    = "states/terraform.tfstate"
    region = "us-west-1"
  }
  required_providers {
    mysql = {
      source  = "winebarrel/mysql"
      version = "~> 1.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
  }
}

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "alinefinacialterraformstatedl"

#   versioning {
#     enabled = true
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# 