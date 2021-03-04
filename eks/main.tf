module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.18"
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  tags            = var.tags

  node_groups = { for launch_template in var.launch_templates : launch_template.name =>
    merge(launch_template, {
      node_group : merge(launch_template.node_group, {
        launch_template_id      = aws_launch_template.this[launch_template.name].id
        launch_template_version = aws_launch_template.this[launch_template.name].default_version
      }),
    })
  }

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
  name_prefix            = "${var.cluster_name}-${each.value["slug"]}-"
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
  # image_id      = var.ami_id

  # If you use a custom AMI, you need to supply via user-data, the bootstrap script as EKS DOESNT merge its managed user-data then
  # you can add more than the minimum code you see in the template, e.g. install SSM agent, see https://github.com/aws/containers-roadmap/issues/593#issuecomment-577181345
  #
  # (optionally you can use https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config to render the script, example: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/997#issuecomment-705286151)

  # user_data = base64encode(
  #   data.template_file.launch_template_userdata.rendered,
  # )


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
