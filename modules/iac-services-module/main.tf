# Local Variables for Naming Convention
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

# Local variables for resource names
locals {
  cluster_name      = "${local.name_prefix}-kafka-cluster"
  redis_cluster_id  = "${local.name_prefix}-redis-cluster"
  subnet_group_name = "${local.name_prefix}-subnet-group"
}

#############################################################################

# Retrieve Data for Services Module
# Retrieve Private Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "db_private_subnet_ids" {
  name = "/${local.name_prefix}/db_subnet_ids"
}

data "aws_ssm_parameter" "kafa_sg_id" {
  name = "/${local.name_prefix}/kafka_sg_id"
}

# Retrieve Elasticache SG Group IDs from SSM Parameter Store
data "aws_ssm_parameter" "elasticache_sg_id" {
  name = "/${local.name_prefix}/elasticache_sg_id"
}

# Retrieve Kafka SG Group IDs from SSM Parameter Store
data "aws_ssm_parameter" "kafka_sg_id" {
  name = "/${local.name_prefix}/kafka_sg_id"
}

###############################################################################

# Create MSK Kafka Cluster
resource "aws_msk_cluster" "kafka" {
  cluster_name           = local.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.availability_zones_count

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    client_subnets  = split(",", data.aws_ssm_parameter.db_private_subnet_ids.value)
    security_groups = [data.aws_ssm_parameter.kafka_sg_id.value]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = local.redis_cluster_id
  engine               = var.elasticache_engine
  node_type            = var.elasticache_node_type
  num_cache_nodes      = 1
  parameter_group_name = var.parameter_group_name
  port                 = var.elasticache_port
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [data.aws_ssm_parameter.elasticache_sg_id.value]
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = local.subnet_group_name
  subnet_ids = split(",", data.aws_ssm_parameter.db_private_subnet_ids.value)
  tags = merge(local.common_tags,
    {
      Name = "${local.subnet_group_name}"
  })
  depends_on = [data.aws_ssm_parameter.db_private_subnet_ids]

  lifecycle {
    create_before_destroy = true
  }
}