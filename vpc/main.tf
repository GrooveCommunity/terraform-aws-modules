locals {

  public_subnets = { for public_subnet in var.public_subnets : "${var.name}-${public_subnet.zone}-${public_subnet.name}" => public_subnet }
  intra_subnets  = { for intra_subnet in var.intra_subnets : "${var.name}-${intra_subnet.zone}-${intra_subnet.name}" => intra_subnet }

  nat_gateway_zones = {
    for nat_gateway in var.nat_gateways : nat_gateway.zone => merge({
      subnet_key = "${var.name}-${nat_gateway.zone}-${nat_gateway.subnet}"
    }, nat_gateway)
  }
}

######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block       = var.cidr
  instance_tenancy = var.instance_tenancy

  enable_dns_hostnames             = false
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
resource "aws_default_network_acl" "this" {

  default_network_acl_id = aws_vpc.this.default_network_acl_id

  subnet_ids = setsubtract(
    compact(flatten([
      aws_subnet.public.*.id,
      aws_subnet.private.*.id,
      aws_subnet.intra.*.id,
    ])),
    compact(flatten([
      aws_network_acl.public.*.subnet_ids,
      aws_network_acl.private.*.subnet_ids,
      aws_network_acl.intra.*.subnet_ids,
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
  for_each = var.public_subnets

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value["cidr"]
  availability_zone               = each.value["zone"]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(
    {
      "Name" = "${each.key}-${each.value["zone"]}-public"
    },
    var.tags,
  )
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

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

  vpc_id = aws_vpc.this.id

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
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}

########################
# Public Network ACLs
########################
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public.*.id

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

#####################################################
# private subnets - private subnet with NAT gateway
#####################################################
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value["cidr"]
  availability_zone               = each.value["zone"]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(
    {
      "Name" = "${each.key}-${each.value["zone"]}-private"
    },
    var.tags,
  )
}

#################
# Private routes
# There are as many routing tables as the number of NAT gateways
#################
resource "aws_route_table" "private" {
  for_each = local.nat_gateway_zones

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.name}-private"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.value["zone"]].id
}

resource "aws_route" "private_nat_gateway" {
  for_each = local.nat_gateway_zones

  route_table_id         = aws_route_table.private[each.value["zone"]].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id

  timeouts {
    create = "5m"
  }
}


##############
# NAT Gateway
##############

resource "aws_eip" "nat" {
  for_each = { for key, zone in local.nat_gateway_zones : key => zone... if lookup(zone, "eip_id", null) != null }

  vpc = true

  tags = merge(
    {
      "Name" = "nat-ip-${var.name}-${each.key}"
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_zones

  allocation_id = lookup(each.value, "eip_id", lookup(lookup(aws_eip.nat, each.key, {}), "id", null))
  subnet_id     = aws_subnet.public[each.value["subnet_key"]].id

  tags = merge(
    {
      "Name" = "nat-${var.name}-${each.key}"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}

########################
# Private Network ACLs
########################
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private.*.id

  tags = merge(
    {
      "Name" = "${var.name}-private-acl"
    },
    var.tags,
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  count = length(var.private_inbound_acl_rules)

  network_acl_id = aws_network_acl.private.id

  egress          = false
  rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  count = length(var.private_outbound_acl_rules)

  network_acl_id = aws_network_acl.private.id

  egress          = true
  rule_number     = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

#####################################################
# intra subnets - private subnet without NAT gateway
#####################################################
resource "aws_subnet" "intra" {
  for_each = var.intra_subnets

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value["cidr"]
  availability_zone               = each.value["zone"]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(
    {
      "Name" = "${each.key}-${each.value["zone"]}-intra"
    },
    var.tags,
  )
}

##########################
# Intra subnet Route Table
##########################
resource "aws_route_table" "intra" {
  count = length(var.intra_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.name}-intra"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "intra" {
  for_each = var.intra_subnets

  subnet_id      = aws_subnet.intra[each.key].id
  route_table_id = aws_route_table.intra[0].id
}

########################
# Intra Network ACLs
########################
resource "aws_network_acl" "intra" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.intra.*.id

  tags = merge(
    {
      "Name" = "${var.name}-intra-acl"
    },
    var.tags,
  )
}

resource "aws_network_acl_rule" "intra_inbound" {
  count = length(var.intra_inbound_acl_rules)

  network_acl_id = aws_network_acl.intra.id

  egress          = false
  rule_number     = var.intra_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.intra_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.intra_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.intra_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.intra_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.intra_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.intra_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.intra_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.intra_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "intra_outbound" {
  count = length(var.intra_outbound_acl_rules)

  network_acl_id = aws_network_acl.intra.id

  egress          = true
  rule_number     = var.intra_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.intra_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.intra_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.intra_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.intra_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.intra_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.intra_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.intra_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.intra_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}
