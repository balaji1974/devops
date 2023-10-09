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
  backend "s3" {
    bucket = "dev-applications-backend-state-balaji-test"
    # key signifies an environment, project name, application name and key name
    #key = "dev/08-backend-state/users/backend-state"
    key = "08-backend-state/users/backend-state"
    region = "me-south-1"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}



resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user"
}

