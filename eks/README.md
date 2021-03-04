## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| template | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eks | terraform-aws-modules/eks/aws | 14.0.0 |

## Resources

| Name |
|------|
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | EKS cluster name | `string` | n/a | yes |
| kms\_key\_arn | KMS key ARN to use if you want to encrypt EKS node root volumes | `string` | `""` | no |
| launch\_templates | Launch templates where node\_group is the var specification for | `list(any)` | <pre>[<br>  {<br>    "instance_type": "t3.micro",<br>    "name": "elasticsearch-data",<br>    "node_group": {<br>      "desired_capacity": 1,<br>      "k8s_labels": {<br>        "purpose": "elasticsearch-data"<br>      },<br>      "key_name": "",<br>      "max_capacity": 3,<br>      "min_capacity": 1<br>    }<br>  },<br>  {<br>    "instance_type": "t3.micro",<br>    "name": "elasticsearch-master",<br>    "node_group": {<br>      "desired_capacity": 1,<br>      "k8s_labels": {<br>        "purpose": "elasticsearch-master"<br>      },<br>      "key_name": "",<br>      "max_capacity": 3,<br>      "min_capacity": 1<br>    }<br>  },<br>  {<br>    "instance_type": "t3.micro",<br>    "name": "kibana-elastalert",<br>    "node_group": {<br>      "desired_capacity": 1,<br>      "k8s_labels": {<br>        "purpose": "kibana-elastalert"<br>      },<br>      "key_name": "",<br>      "max_capacity": 3,<br>      "min_capacity": 1<br>    }<br>  }<br>]</pre> | no |
| subnets | Subnets IDs to put EKS nodes | `list(string)` | n/a | yes |
| tags | Tags to put on resources | `any` | `{}` | no |
| vpc\_id | VPC ID where the EKS instances must be deployed | `string` | n/a | yes |

## Outputs

No output.
