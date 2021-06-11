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