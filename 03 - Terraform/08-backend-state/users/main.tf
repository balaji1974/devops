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
  backend "s3" {
    bucket = "my-dev-backend-state"
    # key signifies an environment, project name, application name and key name
    #key = "dev/07-backend-state/users/backend-state"
    key = "07-backend-state/users/backend-state"
    region = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}
