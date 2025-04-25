
# Create a storage bucket
module "storage" {
  source       = "./modules/iac-storage-module"
  environment  = var.environment
  project_name = var.project_name
  managed_by   = var.managed_by
  owner        = var.owner
  region       = var.region
}

# Create Networking Environment
module "networking" {
  source                              = "./modules/iac-networking-module"
  vpc_cidr                            = var.vpc_cidr
  public_route_table_destination_cidr = var.public_route_table_destination_cidr
  allowed_cidr_blocks                 = var.allowed_cidr_blocks
  availability_zones_count            = var.availability_zones_count
  environment                         = var.environment
  project_name                        = var.project_name
  managed_by                          = var.managed_by
  owner                               = var.owner
  region                              = var.region
}

# Create Security Module
module "security" {
  source                  = "./modules/iac-security-module"
  ssh_port                = var.ssh_port
  mysql_port              = var.mysql_port
  http_port               = var.http_port
  https_port              = var.https_port
  my_ip                   = var.my_ip
  redis_port              = var.redis_port
  kafka_port              = var.kafka_port
  postgres_port           = var.postgres_port
  public_destination_cidr = var.public_destination_cidr
  environment             = var.environment
  project_name            = var.project_name
  managed_by              = var.managed_by
  owner                   = var.owner
  region                  = var.region

  depends_on = [module.networking]
}

# Create IAM Module
module "iam" {
  source                                   = "./modules/iac-iam-module"
  iam_ssm_fullaccess_policy_arn            = var.ssm_fullaccess_policy_arn
  iam_ssm_maintenance_window_policy_arn    = var.ssm_maintenance_window_policy_arn
  iam_ssm_managed_instance_core_policy_arn = var.ssm_managed_instance_core_policy_arn
  iam_ec2_ssm_policy_arn                   = var.iam_ec2_ssm_policy_arn
  aws_budgets_actions_with_ssm_policy_arn  = var.aws_budgets_actions_with_ssm_policy_arn
  environment                              = var.environment
  project_name                             = var.project_name
  managed_by                               = var.managed_by
  owner                                    = var.owner
  region                                   = var.region
}

# Create Load Balancer Module
module "load_balancer" {
  source                = "./modules/iac-loadbalancer-module"
  alb_type              = var.alb_type
  target_type           = var.target_type
  health_check          = var.health_check
  health_check_port     = var.health_check_port
  health_check_protocol = var.health_check_protocol
  http_port             = var.http_port
  https_port            = var.https_port
  environment           = var.environment
  project_name          = var.project_name
  managed_by            = var.managed_by
  owner                 = var.owner
  region                = var.region

  depends_on = [module.networking, module.security, module.storage]
}

# Create Compute Module
module "compute" {
  source               = "./modules/iac-compute-module"
  region               = var.region
  ec2_instance_type    = var.ec2_instance_type
  project_name         = var.project_name
  managed_by           = var.managed_by
  owner                = var.owner
  environment          = var.environment
  container_port = var.container_port
  container_user = var.container_user
  task_cpu = var.task_cpu
  task_memory = var.task_memory
  cpu_target_value = var.cpu_target_value
  memory_target_value = var.memory_target_value
  ecs_max_capacity = var.ecs_max_capacity
  availability_zones_count = var.availability_zones_count

  depends_on = [module.load_balancer]
}

# # Create Database Module
# module "database" {
#   source            = "./modules/iac-database-module"
#   db_instance_class = var.db_instance_class
#   db_name           = var.db_name
#   db_engine         = var.db_engine
#   db_storage_size   = var.db_storage_size
#   db_username       = var.db_username
#   environment       = var.environment
#   project_name      = var.project_name
#   managed_by        = var.managed_by
#   owner             = var.owner
#   region            = var.region

#   depends_on = [module.networking, module.security, module.storage]
# }

# # Create Services Module
# module "services" {
#   source                   = "./modules/iac-services-module"
#   elasticache_engine       = var.elasticache_engine
#   elasticache_port         = var.elasticache_port
#   kafka_version            = var.kafka_version
#   kafka_instance_type      = var.kafka_instance_type
#   availability_zones_count = var.availability_zones_count
#   elasticache_node_type    = var.elasticache_node_type
#   parameter_group_name     = var.elasticache_parameter_group_name
#   environment              = var.environment
#   project_name             = var.project_name
#   managed_by               = var.managed_by
#   owner                    = var.owner
#   region                   = var.region

#   depends_on = [module.networking, module.security]
# }