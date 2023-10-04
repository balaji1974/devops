variable "my_iam_users_variable" {
  default = "my_iam_users"
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

# plan - execute 
# Create multiple users at the same time
resource "aws_iam_user" "my_iam_users" {
  count = 2
  name  = "${var.my_iam_users_variable}_${count.index}"
}