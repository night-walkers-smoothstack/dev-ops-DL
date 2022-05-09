resource "aws_db_instance" "aline-db" {
  # name                    = var.name
  identifier              = var.identifier
  allocated_storage       = var.allocated_storage # gigabytes
  backup_retention_period = 7                     # in days
  db_subnet_group_name    = var.db_subnet_group_name
  engine                  = var.engine         # mysql
  engine_version          = var.engine_version # "8.0.27"

  instance_class    = var.instance_class
  storage_encrypted = true
  storage_type      = var.storage_type

  multi_az             = false
  parameter_group_name = aws_db_parameter_group.this.name
  username             = var.db_root_username
  password             = var.db_root_password # "${trimspace(file("${path.module}/secrets/mydb1-password.txt"))}"
  db_name              = var.db_name
  port                 = var.port
  publicly_accessible  = var.publicly_accessible

  vpc_security_group_ids = var.security_groups_ids
  skip_final_snapshot    = false

  snapshot_identifier       = null # no snapshot on initial apply
  final_snapshot_identifier = "aline-db-${formatdate("YYYMMDDhhmmss", timestamp())}"
  lifecycle {
    ignore_changes = [
      password,
      final_snapshot_identifier,
      snapshot_identifier # # snapshot will be applied on subsiquent applies
    ]
  }
  tags = merge(
    { name = var.identifier },
    var.tags
  )
}


resource "aws_db_parameter_group" "this" {
  name   = var.identifier
  family = "mysql8.0"

  parameter {
    name  = "wait_timeout"
    value = "300"
  }

  parameter {
    name  = "interactive_timeout"
    value = "1800"
  }

  tags = merge(
    { name = var.identifier },
    var.tags
  )
}

# TODO add explicit cloudwatch support
