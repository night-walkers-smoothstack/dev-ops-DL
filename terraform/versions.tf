terraform {
  required_version = ">= 1.1.7"

  backend "s3" {
    bucket = "aline-finacial-east-dylan-l"
    key    = "states/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.11"
    }
    mysql = {
      source  = "winebarrel/mysql"
      version = "> 1.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "> 2.5"
    }
  }
}
