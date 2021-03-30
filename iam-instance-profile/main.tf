resource "aws_iam_instance_profile" "instance_profile" {
  name = var.profile_name
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = var.role_name
  path = var.role_path
  assume_role_policy = var.assume_role_policy
}