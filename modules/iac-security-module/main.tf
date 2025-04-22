# Local varibales for Naming conventions

locals {
  # Naming convention for resources
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
  rds_sg_name         = "${local.name_prefix}-rds-sg"
  alb_sg_name         = "${local.name_prefix}-alb-sg"
  asg_sg_name         = "${local.name_prefix}-asg-sg"
  bastion_sg_name     = "${local.name_prefix}-admin-sg"
  kafka_sg_name       = "${local.name_prefix}-kafka-sg"
  elasticache_sg_name = "${local.name_prefix}-elasticache-sg"
}

#######################################################################################################

# Retrieve VPC ID from SSM
data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.name_prefix}/vpc_id"
}

#######################################################################################################

# Create Security Group for ASG
resource "aws_security_group" "asg_sg" {
  name        = local.asg_sg_name
  description = "Security group for ASG"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  ingress {
    description = "Allow SSH traffic from anywhere"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidr_blocks
  }
  egress {
    description = "Allow all traffic to anywhere"
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = merge(local.common_tags,
    {
      Name = "${local.asg_sg_name}"
  })
}

# Create Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = local.rds_sg_name
  description = "Allow MySQL"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = merge(local.common_tags, {
    Name = local.rds_sg_name
  })
}

# Create Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = local.alb_sg_name
  description = "Security group for ALB"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  ingress {
    description = "Allow HTTPS traffic to ALB"
    from_port   = var.alb_https_port
    to_port     = var.alb_https_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all traffic to anywhere"
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = merge(local.common_tags, {
    Name = local.alb_sg_name
  })
}

# Create Security Group for Admin Instance
resource "aws_security_group" "admin_sg" {
  name        = local.bastion_sg_name
  description = "Security group for Bastion Host"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  egress {
    description = "Allow traffic to anywhere"
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }
}

# Create Security Group for Kafka
resource "aws_security_group" "kafka_sg" {
  name        = local.kafka_sg_name
  description = "Security group for Kafka"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  ingress {
    description = "Allow traffic from anywhere"
    from_port   = var.kafka_port
    to_port     = var.kafka_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all traffic to anywhere"
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = merge(local.common_tags, {
    Name = local.kafka_sg_name
  })
}

# Create Security Group for ElastiCache
resource "aws_security_group" "elasticache_sg" {
  name        = local.elasticache_sg_name
  description = "Security group for ElastiCache"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  ingress {
    description = "Allow traffic from anywhere"
    from_port   = var.elasticache_port
    to_port     = var.elasticache_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidr_blocks
  }
  egress {
    description = "Allow all traffic to anywhere"
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }
  tags = merge(local.common_tags, {
    Name = local.elasticache_sg_name
  })
}

######################################################################################################
# Store SG IDS in SSM Parameter Store

# Store RDS Security Group ID in SSM
resource "aws_ssm_parameter" "rds_sg_id" {
  name       = "/${local.name_prefix}/rds_sg_id"
  type       = "String"
  value      = aws_security_group.rds_sg.id
  depends_on = [aws_security_group.rds_sg]

  tags = local.common_tags
}

# Store ALB Security Group ID in SSM
resource "aws_ssm_parameter" "alb_sg_id" {
  name       = "/${local.name_prefix}/alb_sg_id"
  type       = "String"
  value      = aws_security_group.alb_sg.id
  depends_on = [aws_security_group.alb_sg]

  tags = local.common_tags
}

# Store Admin Security Group ID in SSM
resource "aws_ssm_parameter" "admin_sg_id" {
  name       = "/${local.name_prefix}/admin_sg_id"
  type       = "String"
  value      = aws_security_group.admin_sg.id
  depends_on = [aws_security_group.admin_sg]

  tags = local.common_tags
}

resource "aws_ssm_parameter" "asg_sg_id" {

  name       = "/${local.name_prefix}/asg_sg_id"
  type       = "String"
  value      = aws_security_group.admin_sg.id
  depends_on = [aws_security_group.asg_sg]

  tags = local.common_tags
}

# Store Kafka Security Group ID in SSM
resource "aws_ssm_parameter" "kafka_sg_id" {
  name  = "/${local.name_prefix}/kafka_sg_id"
  type  = "String"
  value = aws_security_group.kafka_sg.id

  depends_on = [aws_security_group.kafka_sg]

  tags = local.common_tags
}

# Store Elasticache Security Group ID in SSM
resource "aws_ssm_parameter" "elasticache_sg_id" {
  name  = "/${local.name_prefix}/elasticache_sg_id"
  type  = "String"
  value = aws_security_group.elasticache_sg.id

  depends_on = [aws_security_group.elasticache_sg]

  tags = local.common_tags
}
