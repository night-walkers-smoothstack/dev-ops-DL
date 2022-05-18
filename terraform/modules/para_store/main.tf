resource "aws_ssm_parameter" "strings" {
  for_each = var.strings
  name     = each.value["name"]
  value    = each.value["value"]

  type = "String"
  tier = each.value["tier"]

  lifecycle {
    ignore_changes = [
      value,
      tags
    ]
  }
  tags = var.tags
}

resource "aws_ssm_parameter" "secure" {
  for_each = var.string_params
  name     = each.value["name"]
  value    = each.value["value"]

  type = "SecureString"

  lifecycle {
    ignore_changes = [
      value,
      tags
    ]
  }
  tags = var.tags
}

resource "aws_ssm_parameter" "list" {
  for_each = var.string_params
  name     = each.value["name"]
  value    = each.value["value"]

  type = "StringList"

  lifecycle {
    ignore_changes = [
      value,
      tags
    ]
  }
  tags = var.tags
}