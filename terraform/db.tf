module "db" {
  depends_on          = [module.vpc]
  source              = "terraform-aws-modules/rds/aws"
  publicly_accessible = true

  identifier = "aline-db"

  engine               = "mysql"
  engine_version       = "8.0.27"
  instance_class       = var.instance_class
  allocated_storage    = 5
  major_engine_version = "8.0"

  random_password_length = 32
  db_name  = var.db_name
  password = var.db_root_password
  
  username = var.db_root
  port     = var.db_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.rds.id]

  #   maintenance_window = "Mon:00:00-Mon:03:00"
  #   backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  #   monitoring_interval = "30"
  #   monitoring_role_name = "MyRDSMonitoringRole"
  #   create_monitoring_role = true

  tags = {
    Owner       = var.creator
    Environment = var.Environment
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets

  # DB parameter group
  family = "mysql8.0"

  # Database Deletion Protection
  #   deletion_protection = true

  parameters = [
    {
      name  = "wait_timeout"
      value = "300"
    },
    {
      name  = "interactive_timeout"
      value = "1800"
    }
  ]

  #   options = [
  #     {
  #       option_name = "MARIADB_AUDIT_PLUGIN"

  #       option_settings = [
  #         {
  #           name  = "SERVER_AUDIT_EVENTS"
  #           value = "CONNECT"
  #         },
  #         {
  #           name  = "SERVER_AUDIT_FILE_ROTATIONS"
  #           value = "37"
  #         },
  #       ]
  #     },
  #   ]

}

resource "aws_security_group" "rds" {
  name        = "RDS Security Group"
  description = "allow_traffic to and from RDS instance"
  vpc_id      = module.vpc.vpc_id

  # ingress {
  #   description = "Traffic  RDS"
  #   from_port   = var.db_port
  #   to_port     = var.db_port
  #   protocol    = "tcp"
  #   cidr_blocks = module.vpc.database_subnets_cidr_blocks
  #   # ipv6_cidr_blocks = module.vpc.database_subnets_ipv6_cidr_blocks
  # }

  # egress {
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  tags = {
    Environment = var.Environment
    Owner       = var.creator
  }
}

resource "aws_security_group_rule" "ingress" {
    security_group_id = aws_security_group.rds.id
    type = "ingress"
    description = "Traffic  RDS"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = module.vpc.database_subnets_cidr_blocks
    # ipv6_cidr_blocks = module.vpc.database_subnets_ipv6_cidr_blocks
}

resource "aws_security_group_rule" "egress" {
    security_group_id = aws_security_group.rds.id
    type = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
}

// create database

# provider "mysql" {
#   endpoint = module.db.db_instance_endpoint
#   username = module.db.db_instance_username
#   password = module.db.db_instance_password
# }

# resource "mysql_user" "user" {
#   user               = var.db_username
#   plaintext_password = var.db_password
# }
