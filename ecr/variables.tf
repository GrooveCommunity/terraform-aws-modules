variable "ecr_iam_role" {
  description = "IAM Role for ECr"
  type = string
  default = ""
}

variable "environment" {
  description = "Environment to use as stage"
  type = string
  default = ""
}

variable "repository_name" {
  description = "repository name"
  type = string
  default = ""
}

variable "repository_namespace" {
  description = "Namespace to append to image repo. e.g: groove/nginx"
  type = string
  default = ""
}

variable "image_names" {
  description = "List of repositories to be created"
  type = list(string)
  default = []
}
