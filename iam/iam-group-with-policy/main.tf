module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 3.0"

  name = var.group_name

  group_users = var.group_users

  attach_iam_self_management_policy = var.attach_iam_self_management_policy

  custom_group_policy_arns = var.custom_group_policy_arns

  custom_group_policies = var.custom_group_policies
}