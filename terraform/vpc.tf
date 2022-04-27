data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source                         = "terraform-aws-modules/vpc/aws"
  version                        = "3.4.0"
  name                           = "vpc-serverless"
  cidr                           = "10.0.0.0/16"
  azs                            = data.aws_availability_zones.available.names
  private_subnets                = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  public_subnets                 = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  database_subnets               = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  enable_nat_gateway             = true
  single_nat_gateway             = true
  enable_dns_hostnames           = true
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_name    = "vpc-serverless-security-group"

  public_subnet_tags = {
    "kubernetes.io/cluster/vpc-serverless" = "shared"
    "kubernetes.io/role/elb"               = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/vpc-serverless" = "shared"
    "kubernetes.io/role/internal-elb"      = "1"
  }

  tags = {
    "kubernetes.io/cluster/vpc-serverless" = "shared"
    Environment                            = var.Environment
    Owner                                  = var.creator
  }

}