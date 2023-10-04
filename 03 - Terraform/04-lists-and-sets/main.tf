variable "names" {
  default = ["bala", "havisha", "haasya", "krithika"]
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
  #count = length(var.names)
  #name  = var.names[count.index]
  for_each=toset(var.names)  
  name=each.value  
}