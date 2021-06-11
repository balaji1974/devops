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

# plan - execute 
# first parameter to resource - type of the resource prefixed with the cloud provider name
# second parameter to resource - internal terraform name given for our bucket
resource "aws_s3_bucket" "my_s3_bucket" {
    # this is the bucket's globally unique name in AWS, note: underscore is invalid in bucket name
    bucket = "my-s3-bucket-balaji-test-001"
    # this will enable versioning on the resource created
    versioning {
        enabled = true
    }
}


resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_balaji"
}

# to output value of a variable 
# output "my_s3_bucket_versioning" is the name of the output 
# value = is the value of the variable for which we need the output 
output "my_s3_bucket_versioning" {
  value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}

# to output value of a variable 
# output "my_s3_bucket_complete_details" is the name of the output 
# value = is the value of the variable for which we need complete details 
output "my_s3_bucket_complete_details" {
  value = aws_s3_bucket.my_s3_bucket
}

output "my_iam_user_complete_details" {
  value = aws_iam_user.my_iam_user
}