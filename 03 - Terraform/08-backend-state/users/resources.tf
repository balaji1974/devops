resource "aws_iam_user" "my_iam_user" {
  name = "${terraform.workspace}-my_iam_user_balaji"
}