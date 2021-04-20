data "aws_iam_role" "ecr" {
  name = "workers"
}

module "ecr" {
  source = "cloudposse/ecr/aws"
  namespace              = var.namespace
  stage                  = var.stage
  name                   = var.name
  max_image_count 	 = var.max_image_count
  use_fullname		 = var.use_fullname
  image_names		 = var.image_names
  principals_full_access = [data.aws_iam_role.ecr.arn]
}
