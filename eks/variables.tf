variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS instances must be deployed"
  type        = string
}

variable "subnets" {
  description = "Subnets IDs to put EKS nodes"
  type        = list(string)
}

variable "tags" {
  description = "Tags to put on resources"
  type        = any
  default     = {}
}

variable "workers_additional_policies" {
  description = "IAM Policies to be added to the workers"
  type        = list(string)
  default     = ["ecr-full-perm"]
}

variable "launch_templates" {
  description = "Launch templates where node_group is the var specification for "
  type        = list(any)
  default = [

    {
      name          = "elasticsearch-data"
      instance_type = "t3.micro"
      # https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
      ami_id = ""
      node_group = {
        desired_capacity = 1
        max_capacity     = 3
        min_capacity     = 1
        key_name         = ""
        k8s_labels = {
          purpose = "elasticsearch-data"
        }
      }
    },

    {
      name          = "elasticsearch-master"
      instance_type = "t3.micro"
      ami_id        = ""
      node_group = {
        desired_capacity = 1
        max_capacity     = 3
        min_capacity     = 1
        key_name         = ""
        k8s_labels = {
          purpose = "elasticsearch-master"
        }
      }
    },

    {
      name          = "kibana-elastalert"
      instance_type = "t3.micro"
      ami_id        = ""
      node_group = {
        desired_capacity = 1
        max_capacity     = 3
        min_capacity     = 1
        key_name         = ""
        k8s_labels = {
          purpose = "kibana-elastalert"
        }
      }
    }

  ]
}

variable "workers_group_defaults" {
  description = "Defaults for worker group"
  type = any
  default = {
    key_name = "eks-workers"
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN to use if you want to encrypt EKS node root volumes"
  type        = string
  default     = ""
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn = string
    username = string
    groups = list(string)
  }))

  default = []
}
