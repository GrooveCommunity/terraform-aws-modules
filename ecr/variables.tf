variable "namespace" {
  description = "Namespace of the repositories"
  type = string
  default = ""
}

variable "stage" {
  description = "Environment of the repo images e.g staging, prod"
  type = string
  default = ""
}

variable "name" {
  description = "Name of the context, e.g app"
  type = string
  default = ""
}

variable "max_image_count" {
  description = "How many Docker Image versions AWS ECR will store"
  type = number
  default = 20
}

variable "use_fullname" {
  description = "Set 'true' to use `namespace-stage-name` for ecr repository name, else `name`"
  type = bool
  default = false
}

variable "image_names" {
  description = "List of Docker local image names, used as repository names for AWS ECR"
  type = list(string)
  default = []
}
