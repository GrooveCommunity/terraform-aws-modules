variable "policy_name" {
  description = "Policy name to be created"
  type        = string
  default     = "groove-policy"
}

variable "policy_path" {
  description = "Policy path where the policy will be created"
  type        = string
  default     = "/"
}

variable "policy_description" {
  description = "Policy description"
  type        = string
  default     = "the best policy"
}

variable "policy_json_body" {
  description = "Policy name to be created"
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
