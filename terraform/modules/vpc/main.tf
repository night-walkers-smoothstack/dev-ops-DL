# creates vpc and subnet resources necessary to run containerized microservices with a backend database
# author Dylan Luttrell

locals {
  # remove any empty strings from lists
  private_subnets = compact(var.private_subnets)
  public_subnets  = compact(var.public_subnets)
  db_subnets      = compact(var.db_subnets)
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  tags                 = var.tags
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

data "aws_availability_zones" "this" {
  state = "available"
}

################################################################################

# public subnets and resources
resource "aws_subnet" "public" {
  count                   = length(local.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnets[count.index]
  availability_zone       = element(data.aws_availability_zones.this.names, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id

}

################################################################################

# creates a set of subnets dedicated to database
resource "aws_subnet" "db" {
  count                   = length(local.db_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.db_subnets[count.index]
  availability_zone       = element(data.aws_availability_zones.this.names, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "VPC" = aws_vpc.this.id
    },
    var.tags
  )

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_db_subnet_group" "db" {
  count       = length(local.db_subnets) > 0 ? 1 : 0 # create only if subnets exist
  name        = lower(coalesce(aws_vpc.this.id, "-db_subnet_group"))
  description = "Database subnet group"
  subnet_ids = [
    for subnet in aws_subnet.db : subnet.id
  ]

  tags = merge(
    {
      "VPC" = aws_vpc.this.id
    },
    var.tags
  )

  depends_on = [
    aws_subnet.db
  ]
}
################################################################################

# private subnets and related resources
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.this.names, count.index)
  count             = length(local.private_subnets)
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_eip" "nat" {
  count = length(local.private_subnets)
  vpc   = true

  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count             = length(local.private_subnets)
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = aws_subnet.public[count.index].id
  connectivity_type = "public"

  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_route_table" "private" {
  count  = length(local.private_subnets)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
  }
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
################################################################################
# security group resources
resource "aws_security_group" "this" {
  name        = "aline-financial vpc security group"
  description = "regulate trafic in and out of VPC"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = lookup(ingress.value, "protocol", -1)
      cidr_blocks = compact(lookup(ingress.value, "cidr_blocks", []))
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      description = lookup(egress.value, "description", null)
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = lookup(egress.value, "protocol", -1)
      cidr_blocks = compact(lookup(egress.value, "cidr_blocks", []))
    }
  }

  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

################################################################################
# endpoints

# ecr endpoints
resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

# s3 endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

# ecs endpoints
resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.region}.ecs"
  security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecs-telemetry" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.region}.ecs-telemetry"
  security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecs-agent" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.region}.ecs-agent"
  security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

# secret manager endpoint
resource "aws_vpc_endpoint" "secretmanager" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  # private_dns_enabled = true
  service_name = "com.amazonaws.${var.region}.secretsmanager"
  security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  tags = merge(
    { "VPC" = aws_vpc.this.id },
    var.tags
  )
}

resource "aws_lb" "alb" {
  name               = "aline-alb-dl"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  # deploy to private subnets, if any. Else deploy to public.
  subnets = [
    for subnet in aws_subnet.public : subnet.id
  ]

  enable_deletion_protection = false

}
