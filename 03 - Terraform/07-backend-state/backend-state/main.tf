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

resource "aws_s3_bucket" "my_backend_state" {
  bucket = "my-dev-backend-state"
  lifecycle {
    prevent_destroy= true
  }
  versioning {
    enabled=true
  }

  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm="AES256"
        }
    }
  }

}

#Configuration for DynamoDB
resource "aws_dynamodb_table" "my_backend_lock" {
  name = "dev_application_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name= "LockID"
    type="S"
  }
}