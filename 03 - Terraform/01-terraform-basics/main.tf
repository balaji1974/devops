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

# plan - execute 
# first parameter to resource - type of the resource prefixed with the cloud provider name
# second parameter to resource - internal terraform name given for our bucket
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-s3-bucket-balaji-test-001"
}

# Revisioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


# Simple output variable
output "my_s3_bucket_versioning" {
  value=aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}

# Output variable
output "my_s3_bucket_complete_details" {
  value=aws_s3_bucket.my_s3_bucket
}

#Create IAM User
resource "aws_iam_user" "my_iam_user" {
  name = "terraform_iam_user"
}

/* # Use if for modifying the resource
#Update IAM User
resource "aws_iam_user" "my_iam_user" {
  name = "terraform_iam_user_modified"
}
*/





