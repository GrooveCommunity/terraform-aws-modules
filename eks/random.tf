resource "random_pet" "node_groups" {
  for_each = local.node_groups

  separator = "-"
  length    = 2

  keepers = {
    ami_type      = lookup(each.value, "ami_type", null)
    disk_size     = lookup(each.value, "disk_size", null)
    instance_type = lookup(each.value, "instance_type", null)
    iam_role_arn  = lookup(each.value, "iam_role_arn", null)

    key_name = lookup(each.value, "key_name", null)

    source_security_group_ids = join("|", compact(
      lookup(each.value, "source_security_group_ids", [])
    ))
    subnet_ids      = join("|", lookup(each.value, "subnets", []))
    node_group_name = join("-", [var.cluster_name, each.key])
    launch_template = lookup(each.value, "launch_template_id", null)
  }
}
