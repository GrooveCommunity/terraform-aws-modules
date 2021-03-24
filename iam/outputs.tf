output "arn" {
  description = "Policy ARN"
  value = module.iam_policy.arn
}

output "path" {
  description = "Path of the policy in IAM"
  value = module.iam_policy.path
}
