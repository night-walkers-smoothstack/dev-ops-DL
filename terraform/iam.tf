

resource "aws_iam_role" "db_connect" {
  name = "test_role"

  assume_role_policy = file("creds/role.json")

  inline_policy {
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["rds-db:connect"]
          Effect   = "Allow"
          Resource = [module.db.db_instance_arn]
        },
        ]
    })
  }


  tags = {
    Owner       = var.creator
    Environment = var.Environment
  }
}

