variable "region" {
  description = "Define what region the instance will be deployed us-east-1 / sa-east-1"
}

variable "instance_type" {
  description = "AWS Instance type defines the hardware configuration of the machine"
  default = "t3a.medium"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-033845c33c6975427"
}

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
    }
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


