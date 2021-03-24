# IAM Role to be granted ECR permissions
data "aws_iam_role" "ecr" {
  name = var.ecr_iam_role
}

module "ecr" {
  source = "cloudposse/ecr/aws"
  version     = "0.32.2"
  namespace              = var.repository_namespace
  stage                  = var.environment
  name                   = var.repository_name
  image_names            = var.image_names
  principals_full_access = [data.aws_iam_role.ecr.arn]
}