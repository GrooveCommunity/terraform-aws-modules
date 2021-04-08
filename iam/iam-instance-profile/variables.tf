variable "profile_name" {
  description = "Name of the iam profile to be created"
  type        = string
  default     = "groove_profile"
}

variable "role_name" {
  description = "Name of the role that will be created"
  type        = string
  default     = "groove_name"
}

variable "role_path" {
  description = "Path where the role will be created at"
  type        = string
  default     = "/"
}

variable "assume_role_policy" {
  description = "Policy of the role that will be assumed by nodes"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
