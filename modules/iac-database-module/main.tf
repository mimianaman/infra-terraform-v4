# Local Variables for Naming Conventions
locals {
  # Naming convention for resources
  name_prefix = "${terraform.workspace}-${var.project_name}"

  # Common tags for all resources
  common_tags = {
    Environment = terraform.workspace
    Managed_by  = var.managed_by
    Owner       = var.owner
    Project     = "${var.project_name}"
  }
}


# Local variables for mssql db
locals {
  mssql_db_name              = "${local.name_prefix}-mssql-db"
  mysql_db_instance_name     = "${local.name_prefix}-mssql-db-instance"
  mysql_db_subnet_group_name = "${local.name_prefix}-db-subnet-group"
  mysql_secret_name          = "${local.name_prefix}-secret-payjack-db-secrtvt"
}

# Local variables for postgres db
locals {
  postgres_secret_name          = "${local.name_prefix}-secret-payjack-postgres-secretvt"
  postgres_db_name              = "${local.name_prefix}-postgres-db"
  postgres_db_instance_name     = "${local.name_prefix}-postgres-db-instance"
  postgres_db_subnet_group_name = "${local.name_prefix}-postgres-db-subnet-group"
}



#############################################################################

# Create a mssql RDS instance in a VPC with a security group and subnet group
# Create mssql Subnet Group
resource "aws_db_subnet_group" "mssql" {
  name       = local.mysql_db_subnet_group_name
  subnet_ids = split(",", data.aws_ssm_parameter.db_private_subnet_ids.value)
}

# Create Postgres Subnet Group
resource "aws_db_subnet_group" "postgres" {
  name       = local.postgres_db_subnet_group_name
  subnet_ids = split(",", data.aws_ssm_parameter.db_private_subnet_ids.value)
}

# Create a random password for mssql
resource "random_password" "mssql" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "_%#!$^&*"
}

# Create a random password for Postgres
resource "random_password" "postgres" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "_%#!$^&*"
}

# Create A Secret Manager for RDS mssql Credentials
resource "aws_secretsmanager_secret" "mssql" {
  name        = local.mysql_secret_name
  description = "DB Credentials credentials for ${local.mssql_db_name}"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.mssql_db_name}-secret"
  })
}

# Create a Secret Version for RDS mssql DB Credentials
resource "aws_secretsmanager_secret_version" "mssql" {
  secret_id = aws_secretsmanager_secret.mssql.id

  secret_string = jsonencode({
    username = var.mysql_db_username
    password = random_password.mssql.result
  })
}


# Create A Secret Manager for RDS Postgres Credentials
resource "aws_secretsmanager_secret" "postgres" {
  name        = local.postgres_secret_name
  description = "DB Credentials credentials for ${local.postgres_db_name}"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.postgres_db_name}-secret"
  })
}

# Create a Secret Version for RDS Postgres DB Credentials
resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id

  secret_string = jsonencode({
    username = var.postgres_db_username
    password = random_password.postgres.result
  })
}

# Local variables for mssql DB Credentials
locals {
  mssql_db_creds = jsondecode(data.aws_secretsmanager_secret_version.mssql_db_creds.secret_string)

  # depends_on = [aws_secretsmanager_secret_version.mssql]
}

# Local variables for Postgres DB Credentials
locals {
  postgres_db_creds = jsondecode(data.aws_secretsmanager_secret_version.postgres_db_creds.secret_string)

  # depends_on = [aws_secretsmanager_secret_version.postgres]
}

##############################################################################

# Retrieve RDS Data from SSM Parameter Store
# Retrieve Private Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "db_private_subnet_ids" {
  name = "/${local.name_prefix}/db_subnet_ids"
}

data "aws_secretsmanager_secret_version" "mssql_db_creds" {
  secret_id = aws_secretsmanager_secret.mssql.id

  depends_on = [aws_secretsmanager_secret_version.mssql]
}

data "aws_secretsmanager_secret_version" "postgres_db_creds" {
  secret_id = aws_secretsmanager_secret.postgres.id

  depends_on = [aws_secretsmanager_secret_version.postgres]
}

# Retrieve RDS Security Group ID from SSM Parameter Store
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${local.name_prefix}/mysql_sg_id"
}

data "aws_ssm_parameter" "postgres_sg_id" {
  name = "/${local.name_prefix}/postgres_sg_id"
}

#############################################################################
# Create DB Instance
resource "aws_db_instance" "mssql" {
  allocated_storage      = var.db_storage_size
  engine                 = var.mssql_db_engine
  identifier             = local.mysql_db_instance_name
  instance_class         = var.db_instance_class
  username               = local.mssql_db_creds.username
  password               = local.mssql_db_creds.password
  db_name                = var.mssql_db_name
  skip_final_snapshot    = terraform.workspace == "prod" ? false : true
  multi_az               = terraform.workspace == "prod" ? true : false
  publicly_accessible    = false
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  db_subnet_group_name   = aws_db_subnet_group.mssql.name

  # lifecycle {
  #   ignore_changes = [
  #     username,
  #     password,
  #     engine_version,
  #     allocated_storage,
  #     storage_type,
  #     iops,
  #     db_subnet_group_name,
  #     engine,
  #     identifier,
  #     instance_class,
  #     db_name,
  #     vpc_security_group_ids
  #   ]
  # }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.mssql_db_name}"
  })
}

# Create RDS Postgres DB Instance
resource "aws_db_instance" "postgres" {
  identifier             = local.postgres_db_instance_name
  engine                 = var.postgres_db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage_size
  db_name                = var.postgres_db_name
  username               = var.postgres_db_username
  password               = random_password.postgres.result
  vpc_security_group_ids = [data.aws_ssm_parameter.postgres_sg_id.value]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  skip_final_snapshot    = terraform.workspace == "prod" ? false : true
  publicly_accessible    = false
  multi_az               = terraform.workspace == "prod" ? true : false

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
      Name = "${local.postgres_db_name}"
  })
}

# --------------------------------------------------------------------------------------
# Save DB Endpoints in SSM Parameter Store
resource "aws_ssm_parameter" "mysql_db_endpoint" {
  name  = "/${local.name_prefix}/mssql-db-endpoint"
  type  = "String"
  value = aws_db_instance.mssql.endpoint
}

resource "aws_ssm_parameter" "postgres_db_endpoint" {
  name  = "/${local.name_prefix}/postgres-db-endpoint"
  type  = "String"
  value = aws_db_instance.postgres.endpoint
}