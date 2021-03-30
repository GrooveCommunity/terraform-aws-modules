variable "image_tag_mutability" {
  description = "If tags can be multable"
  type = string
  default = "MULTABLE"
}

variable "image_scan_on_push" {
  description = "Namespace to append to image repo. e.g: groove/nginx"
  type = bool
  default = true
}

variable "repository_name" {
  description = "Repository name that will be created"
  type = string
  default = ""
}
