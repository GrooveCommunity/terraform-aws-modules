module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 3.0"

  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy = var.policy_json_body
}
