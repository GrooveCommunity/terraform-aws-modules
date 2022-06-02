locals {

  public_subnets  = { for public_subnet in var.public_subnets : "${var.name}-${public_subnet.zone}-${public_subnet.name}" => public_subnet }

}

provider "aws" {
   region = var.region
}

######
# VPC
######
resource "aws_vpc" "groove" {
  cidr_block       = var.cidr
  instance_tenancy = var.instance_tenancy

  enable_dns_hostnames             = true
  enable_dns_support               = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  assign_generated_ipv6_cidr_block = false

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

#######################
# Default Network ACLs
#######################
resource "aws_default_network_acl" "groove" {

  default_network_acl_id = aws_vpc.groove.default_network_acl_id

  subnet_ids = setsubtract(
    compact(flatten([
      local.public_subnet_ids
    ])),
    compact(flatten([
      aws_network_acl.public.subnet_ids
    ]))
  )

  tags = merge(
    {
      "Name" = "${var.name}-vpc-acl"
    },
    var.tags
  )

}

################
# Public subnet
################
resource "aws_subnet" "public" {
  for_each                        = local.public_subnets

  vpc_id                          = aws_vpc.groove.id
  cidr_block                      = each.value["cidr"]
  availability_zone               = each.value["zone"]
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags                            = merge(
    {
      "Name"                      = "${each.key}-${each.value["zone"]}-public"
    },
    var.tags,
  )
}

locals {
  public_subnet_ids               = [for subnet in aws_subnet.public : subnet.id]
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "groove" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.groove.id

  tags = merge(
    {
      "Name" = "${var.name}-public"
    },
    var.tags,
  )
}

###########################
# Public subnet Route Table
###########################
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.groove.id

  tags = merge(
    {
      "Name" = "${var.name}-public"
    },
    var.tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.groove[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}

########################
# Public Network ACLs
########################
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.groove.id
  subnet_ids = local.public_subnet_ids

  tags = merge(
    {
      "Name" = "${var.name}-public-acl"
    },
    var.tags,
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  count = length(var.public_inbound_acl_rules)

  network_acl_id = aws_network_acl.public.id

  egress          = false
  rule_number     = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  count = length(var.public_outbound_acl_rules)

  network_acl_id = aws_network_acl.public.id

  egress          = true
  rule_number     = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}


#############
# Ec2 pfSense
#############

resource "aws_instance" "pfSense" {
  for_each               = local.public_subnets
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[each.key].id
  vpc_security_group_ids = [aws_security_group.pfsense_first_access.id,aws_security_group.pfsense_trust_openvpn_access.id, aws_security_group.pfsense_trust_ipsec_access.id, aws_security_group.pfsense_trust_ipforce_access.id]
  

  #Não esquecer de remover o security group "FIRST ACCESS" da instancia do pfsense, após a configuração.
  
  root_block_device      {
  delete_on_termination  = true
  volume_size            = 30
}
  tags = {
    "Name"        = "pfSense"
    }
}