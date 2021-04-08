variable "group_name" {
  description = "Name of the group to be created"
  type = string
}

variable "group_users" { 
  description = "Users to attach to group"
  type = list(string)
}

variable "attach_iam_self_management_policy" {
  description = "Attach IAM self management policy"
  type = bool
  default = true
}

variable "custom_group_policies" {
  description = "Custom group policies to add to group"
  type = list(object({
    name = string
    policy = string
  }))
}

variable "custom_group_policy_arns" { 
  description = "ARN of policies to be attached to the group"
  type = list(string)
}
