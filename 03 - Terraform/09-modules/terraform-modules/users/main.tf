 variable "environment" {
   default ="default"
 }

provider "aws" {
  region = "me-south-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # minimum version of terraform needed (optional)
    }
  }
}

locals {
  iam_user_extension="my_iam_user_balaji"
}
