terraform {
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = ">= 5.32.0"
	}

	cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.38.0"
    }
  }

  backend "s3" {
	bucket         = "terraformstatenameadi"
	key            = "terraform.tfstate"
	region         = "us-east-1"
  }
}

provider "aws" {
  region = var.region_name
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}