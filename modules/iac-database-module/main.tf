# Local Variables for Naming Conventions
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
  db_name              = "${local.name_prefix}-db"
  db_instance_name     = "${local.name_prefix}-db-instance"
  db_subnet_group_name = "${local.name_prefix}-db-subnet-group"
  secret_name          = "${local.name_prefix}-secret-payjack-db-secrtsssss"
  db_identifier        = "${local.name_prefix}-db-instance"
}

#############################################################################

# Create a MySQL RDS instance in a VPC with a security group and subnet group
# Create Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = local.db_subnet_group_name
  subnet_ids = split(",", data.aws_ssm_parameter.db_private_subnet_ids.value)
}

# Create a random password for RDS
resource "random_password" "rds" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "_%#!$^&*"
}

# Create A Secret Manager for RDS Credentials
resource "aws_secretsmanager_secret" "rds" {
  name        = local.secret_name
  description = "RDS credentials for ${local.db_name}"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.db_name}-secret"
  })
}

# Create a Secret Version for RDS Credentials
resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds.result
  })
}

# Local variables for DB Credentials
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)

  depends_on = [aws_secretsmanager_secret_version.rds]
}

##############################################################################

# Retrieve RDS Data from SSM Parameter Store
# Fetch Private Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "db_private_subnet_ids" {
  name = "/${local.name_prefix}/db_subnet_ids"
}

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = aws_secretsmanager_secret.rds.id

  depends_on = [aws_secretsmanager_secret_version.rds]
}

# Fetch RDS Security Group ID from SSM Parameter Store
data "aws_ssm_parameter" "rds_sg_id" {
  name = "/${local.name_prefix}/rds_sg_id"
}

#############################################################################
# Create DB Instance
resource "aws_db_instance" "rds" {
  allocated_storage      = var.db_storage_size
  engine                 = var.db_engine
  identifier             = local.db_identifier
  instance_class         = var.db_instance_class
  username               = local.db_creds.username
  password               = local.db_creds.password
  db_name                = var.db_name
  skip_final_snapshot    = terraform.workspace == "prod" ? false : true
  multi_az               = terraform.workspace == "prod" ? true : false
  vpc_security_group_ids = [data.aws_ssm_parameter.rds_sg_id.value]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  lifecycle {
    ignore_changes = [ 
      username,
      password,
      engine_version,
      allocated_storage,
      storage_type,
      iops,
      db_subnet_group_name,
      engine,
      identifier,
      instance_class,
      db_name,
      vpc_security_group_ids
     ]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.db_name}"
  })
}