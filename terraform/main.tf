/* Create any base/shared infrastructure resources using Terraform: VPC, Subnets (private, public), Security Groups, IGW, NAT gateways, route tables, IAM roles and policies, RDS instances, KMS keys, S3 buckets, Application Load Balancers etc. */

provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source = "./modules/vpc"

  region         = var.aws_region
  vpc_cidr_block = "10.1.0.0/16"

  private_subnets = ["10.1.10.0/24", "10.1.11.0/24"]
  public_subnets  = ["10.1.20.0/24", "10.1.21.0/24"]
  db_subnets      = ["10.1.30.0/24", "10.1.31.0/24"]

  security_group_ingress = [
    {
      protocol    = "tcp",
      from_port   = 80,
      to_port     = 80,
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      protocol    = "tcp",
      from_port   = 3306,
      to_port     = 3306,
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  security_group_egress = [
    {
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = var.tags
}

module "rds" {
  identifier = var.identifier
  source     = "./modules/rds"

  engine         = "mysql"
  engine_version = "8.0.27"

  db_root_username = var.db_root
  db_root_password = var.db_root_password
  db_name          = var.db_name
  port             = 3306

  db_username = var.db_username
  db_password = var.db_password

  publicly_accessible = true

  allocated_storage = 20
  storage_type      = "gp2"
  instance_class    = "db.t3.micro"

  db_subnet_group_name = module.vpc.aws_db_subnet_group_name



  security_groups_ids = [module.vpc.aws_security_group_id]

  depends_on = [
    module.vpc
  ]
}