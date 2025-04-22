# Local Variables for Naming conventions
locals {
  name_prefix = "${terraform.workspace}-${var.project_name}-${var.region}"

  # Common tags for all resources
  common_tags = {
    Environment = terraform.workspace
    Managed_by  = var.managed_by
    Owner       = var.owner
    Project     = "${var.project_name}"
  }
}

# Local variables for resource names
locals {
  alb_name             = "${local.name_prefix}-alb"
  target_group_name    = "${local.name_prefix}-tg"
  alb_logs_bucket_name = "${local.name_prefix}-alb-logs"
}

###########################################################################

# Fetch Networking Credentials from SSM Parameter Store
# To be referenced in the ALB Module

# Fetch Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Fetch VPC ID from SSM Parameter Store
data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.name_prefix}/vpc_id"
}

# Fetch Subnet IDS from SSM Parameter Store
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${local.name_prefix}/public_subnet_ids"
}


# Fetch Security ALB Security Group IDs from SSM Parameter Store
data "aws_ssm_parameter" "alb_sg_id" {
  name = "/${local.name_prefix}/alb_sg_id"
}

# Fetch Log Bucket From SSM Parameter Store
data "aws_s3_bucket" "alb_logs" {
  bucket = "${local.name_prefix}-alb-logs-bucket"
}

###########################################################################
# Create ELB Resources

# Create ELB Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name        = local.target_group_name
  port        = var.health_check_port
  protocol    = var.health_check_protocol
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  target_type = var.target_type

  health_check {
    path                = var.health_check.path
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }

  lifecycle {
    ignore_changes = [
      name,
      port,
      protocol,
      target_type,
      vpc_id
    ]
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = local.target_group_name
  })
}

# Create the ALB
resource "aws_lb" "alb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = var.alb_type
  security_groups    = [data.aws_ssm_parameter.alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  # Ensure that ALB drops HTTP headers
  drop_invalid_header_fields = true

  access_logs {
    bucket  = data.aws_s3_bucket.alb_logs.id
    prefix  = terraform.workspace
    enabled = true
  }

  enable_deletion_protection = terraform.workspace == "prod" ? true : false

  tags = merge(local.common_tags, {
    Name = local.alb_name
  })
}

##############################################################################

# Store ELB Credentials in SSM Parameter Store
# Add SSM parameter for target group ARN
resource "aws_ssm_parameter" "alb_target_group_arn" {
  name  = "/${local.name_prefix}/alb_target_group_arn"
  type  = "String"
  value = aws_lb_target_group.alb_target_group.arn

  tags = local.common_tags
}

# Store ALB ARN in SSM Parameter Store
resource "aws_ssm_parameter" "alb_arn" {
  name  = "/${local.name_prefix}/alb_arn"
  type  = "String"
  value = aws_lb.alb.arn

  tags = local.common_tags
}

# Store ALB Zone ID in SSM Parameter Store
resource "aws_ssm_parameter" "alb_zone_id" {
  name  = "/${local.name_prefix}/alb_zone_id"
  type  = "String"
  value = aws_lb.alb.zone_id
  tags  = local.common_tags
}

# Store ALB DNS Name in SSM Parameter Store
resource "aws_ssm_parameter" "alb_dns_name" {
  name  = "/${local.name_prefix}/alb_dns_name"
  type  = "String"
  value = aws_lb.alb.dns_name
  tags  = local.common_tags
}