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

resource "aws_iam_user" "my_iam_user" {
  name="${var.environment}_${local.iam_user_extension}"
}

locals {
  iam_user_extension="my_iam_user_test"
}
