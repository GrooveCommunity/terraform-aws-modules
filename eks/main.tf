# If you need to configure something standard to all clusters use the code below

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

locals {
  node_groups = { for launch_template in var.launch_templates : launch_template.name =>
    merge(launch_template.node_group, {
      subnets                 = lookup(launch_template.node_group, "subnets", var.subnets)
      launch_template_id      = aws_launch_template.this[launch_template.name].id
      launch_template_version = aws_launch_template.this[launch_template.name].default_version
    })
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "13.2.1" # Version 14.0.0 is Broken for Launch Template instance_type flag. https://github.com/terraform-aws-modules/terraform-aws-eks/pull/1221

  cluster_name    	      = var.cluster_name
  cluster_version 	      = "1.18"
  vpc_id          	      = var.vpc_id
  subnets         	      = var.subnets
  tags            	      = var.tags
  workers_additional_policies = var.workers_additional_policies
  

  node_groups = { for k, v in local.node_groups : k =>
    merge(v, {
      name = trim(substr(join("-", [var.cluster_name, k, random_pet.node_groups[k].id]), 0, 63), "-")
    })
  }

  map_roles = var.map_roles
}

data "template_file" "launch_template_userdata" {
  template = file("${path.module}/templates/userdata.sh.tpl")

  vars = {
    cluster_name        = var.cluster_name
    endpoint            = module.eks.cluster_endpoint
    cluster_auth_base64 = module.eks.cluster_certificate_authority_data

    bootstrap_extra_args = ""
    kubelet_extra_args   = ""
  }
}

locals {
  launch_templates = { for launch_template in var.launch_templates : launch_template.name => launch_template }
}

resource "aws_launch_template" "this" {
  for_each               = local.launch_templates
  name_prefix            = "${var.cluster_name}-${each.value["name"]}-"
  description            = "${each.key} nodes"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 60
      volume_type           = "gp2"
      delete_on_termination = true
      # encrypted             = true

      # Enable this if you want to encrypt your node root volumes with a KMS/CMK. encryption of PVCs is handled via k8s StorageClass tho
      # you also need to attach data.aws_iam_policy_document.ebs_decryption.json from the disk_encryption_policy.tf to the KMS/CMK key then !!
      # kms_key_id            = var.kms_key_arn
    }
  }

  instance_type = lookup(each.value, "instance_type", "t2.micro")

  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [module.eks.worker_security_group_id]
  }

  # if you want to use a custom AMI
  image_id = each.value["ami_id"]

  # If you use a custom AMI, you need to supply via user-data, the bootstrap script as EKS DOESNT merge its managed user-data then
  # you can add more than the minimum code you see in the template, e.g. install SSM agent, see https://github.com/aws/containers-roadmap/issues/593#issuecomment-577181345
  #
  # (optionally you can use https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config to render the script, example: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/997#issuecomment-705286151)

  user_data = base64encode(
    data.template_file.launch_template_userdata.rendered,
  )


  # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        node_group = each.key
      }
    )
  }

  # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC tho)
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.tags,
      {
        node_group = each.key
      }
    )
  }

  # Tag the LT itself
  tags = merge(
    var.tags,
    {
      node_group = each.key
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "kubeconfig" {
  sensitive_content = module.eks.kubeconfig
  filename          = "${path.cwd}/${module.eks.kubeconfig_filename}"
}
