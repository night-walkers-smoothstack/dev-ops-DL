# data "aws_iam_policy_document" "db_connect_policy" {
#   version = "2012-10-17"
#   Statement {
#     actions = ["rds-db:connect"]
#     effect  = "Allow"

#     principals {
#       type        = "Service"
#       resources = [
#         module.db.db_instance_resource_id
#       ]
#     }
#   }
# }

# resource "aws_iam_policy" "rds" {
#   name = "policy-618033"

#   policy = 
# }

resource "aws_iam_role" "db_connect" {
  name = "test_role"

  # assume_role_policy = aws_iam_policy.rds

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["rds-db:connect"]
        Effect   = "Allow"
        Resource = module.db.db_instance_arn
      },
    ]
  })

  tags = {
    Owner       = var.creator
    Environment = var.Environment
  }
}
