locals {
  public_subnets = { for public_subnet in var.public_subnets : "${var.name}-${public_subnet.zone}-${public_subnet.name}" => public_subnet }
  intra_subnets  = { for intra_subnet in var.intra_subnets : "${var.name}-${intra_subnet.zone}-${intra_subnet.name}" => intra_subnet }
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

################
# Public subnet
################
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value["cidr"]
  availability_zone               = each.value["zone"]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(
    {
      "Name" = each.key
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
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}


#####################################################
# intra subnets - private subnet without NAT gateway
#####################################################
resource "aws_subnet" "intra" {
  for_each = local.intra_subnets

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value["cidr"]
  availability_zone               = each.value["zone"]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  ipv6_cidr_block                 = null

  tags = merge(
    {
      "Name" = each.key
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
  for_each = local.intra_subnets

  subnet_id      = aws_subnet.intra[each.key].id
  route_table_id = aws_route_table.intra[0].id
}
