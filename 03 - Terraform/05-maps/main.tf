variable "users" {
  default = {
    bala : { country : "India", department : "IT" },
    havisha : { country : "Netherlands", department : "HR" },
    haasya : { country : "UK", department : "SupplyChain" },
    krithika : { country : "US", department : "Finance" }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }
}

