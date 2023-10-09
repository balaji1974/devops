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
  name = "${terraform.workspace}-my_iam_user"
}
