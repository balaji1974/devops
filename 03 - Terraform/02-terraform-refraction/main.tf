terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # minimum version of terraform needed (optional)
    }
  }
}

provider "aws"{
    region="us-east-1" # region that we need our infrastruce
}






