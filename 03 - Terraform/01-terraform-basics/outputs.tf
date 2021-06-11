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