output "instance_profile_name" {
  description = "Profile name"
  value = aws_iam_instance_profile.instance_profile.name
}