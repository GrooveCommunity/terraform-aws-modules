## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| local | n/a |
| template | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eks | terraform-aws-modules/eks/aws | 13.2.1 |

## Resources

| Name |
|------|
| [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) |
| [aws_eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) |
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | EKS cluster name | `string` | n/a | yes |
| kms\_key\_arn | KMS key ARN to use if you want to encrypt EKS node root volumes | `string` | `""` | no |
| launch\_templates | Launch templates where node\_group is the var specification for | `list(any)` | <pre>[<br>  {<br>    "ami_id": "",<br>    "instance_type": "t3.micro",<br>    "name": "elasticsearch-data",<br>    "node_group": {<br>      "desired_capacity": 1,<br>      "k8s_labels": {<br>        "purpose": "elasticsearch-data"<br>      },<br>      "key_name": "",<br>      "max_capacity": 3,<br>      "min_capacity": 1<br>    }<br>  },<br>  {<br>    "ami_id": "",<br>    "instance_type": "t3.micro",<br>    "name": "elasticsearch-master",<br>    "node_group": {<br>      "desired_capacity": 1,<br>      "k8s_labels": {<br>        "purpose": "elasticsearch-master"<br>      },<br>      "key_name": "",<br>      "max_capacity": 3,<br>      "min_capacity": 1<br>    }<br>  },<br>  {<br>    "ami_id": "",<br>    "instance_type": "t3.micro",<br>    "name": "kibana-elastalert",<br>    "node_group": {<br>      "desired_capacity": 1,<br>      "k8s_labels": {<br>        "purpose": "kibana-elastalert"<br>      },<br>      "key_name": "",<br>      "max_capacity": 3,<br>      "min_capacity": 1<br>    }<br>  }<br>]</pre> | no |
| map\_users | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn = string<br>    username = string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| subnets | Subnets IDs to put EKS nodes | `list(string)` | n/a | yes |
| tags | Tags to put on resources | `any` | `{}` | no |
| vpc\_id | VPC ID where the EKS instances must be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_arn | The Amazon Resource Name (ARN) of the cluster. |
| cluster\_certificate\_authority\_data | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. |
| cluster\_endpoint | The endpoint for your EKS Kubernetes API. |
| cluster\_id | The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready |
| cluster\_version | The Kubernetes server version for the EKS cluster. |
| config\_map\_aws\_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kubeconfig | kubectl config file contents for this EKS cluster. |
| kubeconfig\_filename | The filename of the generated kubectl config. |
| kubeconfig\_filepath | The file path (directory + filename) of the generated kubectl config. |
