#Create IAM User

resource "aws_iam_user" "my_iam_user" {
  name = "terraform_iam_user"
}

/*
# Use if for modifying the resource
#Update IAM User
resource "aws_iam_user" "my_iam_user" {
  name = "terraform_iam_user_modified"
}
*/
