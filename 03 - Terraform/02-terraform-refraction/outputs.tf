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