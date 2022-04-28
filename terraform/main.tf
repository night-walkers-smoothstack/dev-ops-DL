/* Create any base/shared infrastructure resources using Terraform: VPC, Subnets (private, public), Security Groups, IGW, NAT gateways, route tables, IAM roles and policies, RDS instances, KMS keys, S3 buckets, Application Load Balancers etc. */

provider "aws" {
  region = var.aws_region
}