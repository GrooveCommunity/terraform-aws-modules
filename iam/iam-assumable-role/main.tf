module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 3.0"

  trusted_role_arns = var.trusted_role_arns
  create_role = true
  role_name         = var.role_name
  role_requires_mfa = var.role_requires_mfa
  custom_role_policy_arns = var.custom_role_policy_arns
  number_of_custom_role_policy_arns = var.number_of_custom_role_policy_arns
}
