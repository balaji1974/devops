 variable "environment" {
   default ="default"
 }

provider "aws"{
    region="us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  iam_user_extension="my_iam_user_balaji"
}
