variable "trusted_role_arns" {
  description = "Users ARN to allow assume this role"
  type = list(string)
  default = ["arn:aws:iam::139012737147:user/renato.martins"]
}

variable "role_name" {
  description = "Role name"
  type = string
  default = "SRE"
}

variable "role_requires_mfa" {
  description = "If role requires MFA to assume"
  type = bool
  default = false
}

variable "custom_role_policy_arns" {
  description = "Policies to be attached to this role"
  type = list(string)
  default = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

variable "number_of_custom_role_policy_arns" {
  description = "Number of policies attached to this roles (count of custom_role_policy_arns)"
  type = number
  default = 1 
} 
