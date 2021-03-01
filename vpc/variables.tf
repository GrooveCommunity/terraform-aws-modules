variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.30.0.0/16"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "Additional tags for the VPC"
  type        = any
  default     = {}
}

variable "public_subnets" {
  description = "Public subnets specification"
  type        = list(any)
  default = [
    {
      name = "public"
      cidr = "10.30.0.0/24"
      zone = "us-east-1a"
    },
    {
      name = "public"
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


variable "private_subnets" {
  description = "Private subnets specification"
  type        = list(any)
  default = [
    {
      name = "private"
      cidr = "10.30.4.0/24"
      zone = "us-east-1a"
    },
    {
      name = "private"
      cidr = "10.30.5.0/24"
      zone = "us-east-1f"
    },
  ]
}

variable "nat_gateways" {
  description = "Availability zones to deploy AWS NAT Gateway for private subnets"
  type        = list(any)
  default = [
    {
      subnet = "public"
      zone   = "us-east-1a"
      # eip_id = aws_eip.nat.id
    },
    {
      subnet = "public"
      zone   = "us-east-1f"
    }
  ]
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}


variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "intra_inbound_acl_rules" {
  description = "Intra subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "intra_outbound_acl_rules" {
  description = "Intra subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}
