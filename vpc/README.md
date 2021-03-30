## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_default_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) |
| [aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) |
| [aws_network_acl_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `"10.30.0.0/16"` | no |
| instance\_tenancy | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| intra\_inbound\_acl\_rules | Intra subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| intra\_outbound\_acl\_rules | Intra subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| intra\_subnets | Intra subnets specification | `list(any)` | <pre>[<br>  {<br>    "cidr": "10.30.2.0/24",<br>    "name": "intra",<br>    "zone": "us-east-1a"<br>  },<br>  {<br>    "cidr": "10.30.3.0/24",<br>    "name": "intra",<br>    "zone": "us-east-1f"<br>  }<br>]</pre> | no |
| name | Name to be used on all the resources as identifier | `string` | n/a | yes |
| nat\_gateways | Availability zones to deploy AWS NAT Gateway for private subnets | `list(any)` | <pre>[<br>  {<br>    "subnet": "public",<br>    "zone": "us-east-1a"<br>  },<br>  {<br>    "subnet": "public",<br>    "zone": "us-east-1f"<br>  }<br>]</pre> | no |
| private\_inbound\_acl\_rules | Private subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_outbound\_acl\_rules | Private subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_subnets | Private subnets specification | `list(any)` | <pre>[<br>  {<br>    "cidr": "10.30.4.0/24",<br>    "name": "private",<br>    "zone": "us-east-1a"<br>  },<br>  {<br>    "cidr": "10.30.5.0/24",<br>    "name": "private",<br>    "zone": "us-east-1f"<br>  }<br>]</pre> | no |
| public\_inbound\_acl\_rules | Public subnets inbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_outbound\_acl\_rules | Public subnets outbound network ACLs | `list(map(string))` | <pre>[<br>  {<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_action": "allow",<br>    "rule_number": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_subnets | Public subnets specification | `list(any)` | <pre>[<br>  {<br>    "cidr": "10.30.0.0/24",<br>    "name": "public",<br>    "zone": "us-east-1a"<br>  },<br>  {<br>    "cidr": "10.30.1.0/24",<br>    "name": "public",<br>    "zone": "us-east-1f"<br>  }<br>]</pre> | no |
| tags | Additional tags for the VPC | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| intra\_subnet\_ids | Intra subnet IDs. |
| intra\_subnets | Intra subnets attributes. |
| private\_subnet\_ids | Private subnet IDs. |
| private\_subnets | Private subnets attributes. |
| public\_subnet\_ids | Public subnet IDs. |
| public\_subnets | Public subnets attributes. |
| vpc\_id | VPC ID. |
