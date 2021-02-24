variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "Additional tags for the VPC"
  type        = map(any)
  default     = {}
}

variable "public_subnets" {
  description = "Public subnets specification"
  type        = list(any)
  default = [
    {
      name = "pfsense"
      cidr = "10.30.0.0/24"
      zone = "us-east-1a"
    },
    {
      name = "pfsense"
      cidr = "10.30.1.0/24"
      zone = "us-east-1f"
    },
  ]
}

variable "intra_subnets" {
  description = "Intra subnets specification"
  type        = list(any)
  default = [
    {
      name = "intra"
      cidr = "10.30.2.0/24"
      zone = "us-east-1a"
    },
    {
      name = "intra"
      cidr = "10.30.3.0/24"
      zone = "us-east-1f"
    },
  ]
}
