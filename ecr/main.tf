resource "aws_ecr_repository" "repository"  {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push
  }
}