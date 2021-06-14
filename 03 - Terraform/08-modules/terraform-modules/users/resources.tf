resource "aws_iam_user" "my_iam_user" {
  name = "${var.environment}-${local.iam_user_extension}"
}